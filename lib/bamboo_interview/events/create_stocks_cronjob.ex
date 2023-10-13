defmodule BambooInterview.Events.CreateStocksCronJob do
  use GenServer
  alias BambooInterviewWeb.Validators.Stock, as: StockValidator
  require Logger

  def start_link(_opts) do
    # run_interval = 5000
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    # enable Pubsub.subscribe to listen from stocks gateway Pubsub for newly listed stocks
    Phoenix.PubSub.subscribe(BambooInterview.PubSub, "newly_listed_stocks")
    # enable cron jon to always call stocks api
    cron_job_schedule_timer()
    {:ok, nil}
  end

  def handle_info(:check_stock_gateway, state) do
    # check  stock api to see if there is new listed stocks 
    new_stocks = BambooInterview.Stocks.get_newly_listed_stocks()

    # Schedule cron job to call stocks api at specific intervals
    # to check for newly listed stocks
    cron_job_schedule_timer()

    {:noreply, state}
  end

  # @impl true
  # def handle_continue(:schedule_next_run, run_interval) do
  #   Process.send_after(self(), :perform_cron_work, run_interval)
  #   {:noreply, run_interval}
  # end

  @impl true
  def handle_info(new_stocks, state) when new_stocks == [] do
    {:noreply, state}
  end

  @impl true
  def handle_info(new_stocks, state) when new_stocks != [] do
    Enum.each(new_stocks, &setup_new_stock(&1))

    {:noreply, state}
  end

  # @impl true
  # def handle_info(:inform_user_about_new_stock, state) do
  #   IO.inspect("inform new user here")

  #   {:noreply, state}
  # end

  def cron_job_schedule_timer(), do: Process.send_after(self(), :check_stock_gateway, 5000)

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
