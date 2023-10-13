defmodule BambooInterview.Events.CreateStocksCronJob do
  @moduledoc """
    This Module handles the jobs that listens for newly listed stocks
    and periodically checks the newly listed stocks api for newly added
    stocks
    If new stocks exist: 
    1. it processes and stores the data in the database
    2. it send necessary notifications to the users who has subscribed to 
    that stock category
    
  """
  use GenServer
  alias BambooInterviewWeb.Validators.Stock, as: StockValidator
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
    Enable Phoenix.Pubsub.subscribe to listen from stocks gateway for newly listed stocks
    enable cron job to periodically call stocks api to check for newly added stocks
  """
  @impl true
  def init(_opts) do
    Phoenix.PubSub.subscribe(BambooInterview.PubSub, "newly_listed_stocks")

    cron_job_schedule_timer()
    {:ok, nil}
  end

  @doc """
    check  stock api to see if there is new listed stocks 
    Schedule cron job to call stocks api at specific intervals
    to check for newly listed stocks
  """
  def handle_info(:check_stock_gateway, state) do
    BambooInterview.Stocks.get_newly_listed_stocks()

    cron_job_schedule_timer()
    {:noreply, state}
  end

  # returns normal {:noreply, state} when there are no newly added stocks
  @impl true
  def handle_info(new_stocks, state) when new_stocks == [] do
    {:noreply, state}
  end

  @doc """
    process newly added stocks returned from the stocks gateway
  """
  @impl true
  def handle_info(new_stocks, state) when new_stocks != [] do
    Enum.each(new_stocks, &setup_new_stock(&1))

    {:noreply, state}
  end

  @doc """
    cron job timer to run every hour
  """
  def cron_job_schedule_timer(),
    do: Process.send_after(self(), :check_stock_gateway, :timer.hours(1))

  @doc """
    Validate and store the newly added stock in our db
  """
  def setup_new_stock(new_stock) do
    {:ok, category} =
      BambooInterview.Stocks.CompanyCategories.get_or_create(new_stock["category"])

    BambooInterview.Stocks.create_stock(category.id, %StockValidator{
      country: new_stock["country"],
      name: new_stock["name"],
      stock_exchange_type: new_stock["stockExchange"],
      symbol: new_stock["symbol"]
    })
  end
end
