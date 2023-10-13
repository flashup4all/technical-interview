defmodule BambooInterviewWeb.StockJSON do
  alias BambooInterview.Stocks.Stock

  @doc """
  Renders a list of stocks.
  """
  def index(%{stocks: stocks}) do
    %{data: for(stock <- stocks, do: data(stock))}
  end

  @doc """
  Renders a single stock.
  """
  def show(%{stock: stock}) do
    %{data: data(stock)}
  end

  defp data(%Stock{} = stock) do
    %{
      id: stock.id,
      name: stock.name,
      symbol: stock.symbol,
      country: stock.country,
      stock_exchange_type: stock.stock_exchange_type,
      company_category_id: stock.company_category_id
    }
  end
end
