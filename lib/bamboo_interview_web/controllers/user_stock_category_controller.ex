defmodule BambooInterviewWeb.UserStockCategoryController do
  use BambooInterviewWeb, :controller

  alias BambooInterview.Stocks
  alias BambooInterview.Stocks.UserStockCategory

  action_fallback BambooInterviewWeb.FallbackController

  def index(conn, _params) do
    user_stock_category = Stocks.list_user_stock_categories()
    render(conn, :index, user_stock_category: user_stock_category)
  end

  def create(conn, %{"company_category_id" => company_category_id}) do
    user = BambooInterviewWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, %UserStockCategory{} = user_stock_category} <-
           Stocks.create_user_stock_category(user, company_category_id) do
      conn
      |> put_status(:created)
      |> render(:show, user_stock_category: user_stock_category)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user_stock_category} <- Stocks.get_user_stock_category(id) do
      render(conn, :show, user_stock_category: user_stock_category)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %UserStockCategory{}} <- Stocks.delete_user_stock_category(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
