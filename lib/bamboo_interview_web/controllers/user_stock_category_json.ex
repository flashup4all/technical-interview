defmodule BambooInterviewWeb.UserStockCategoryJSON do
  alias BambooInterview.Stocks.UserStockCategory

  @doc """
  Renders a list of user_stock_category.
  """
  def index(%{user_stock_category: user_stock_category}) do
    %{data: for(user_stock_category <- user_stock_category, do: data(user_stock_category))}
  end

  @doc """
  Renders a single user_stock_category.
  """
  def show(%{user_stock_category: user_stock_category}) do
    %{data: data(user_stock_category)}
  end

  defp data(%UserStockCategory{} = user_stock_category) do
    %{
      id: user_stock_category.id,
      user_id: user_stock_category.user_id,
      company_category_id: user_stock_category.company_category_id
    }
  end
end
