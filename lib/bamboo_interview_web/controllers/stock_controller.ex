defmodule BambooInterviewWeb.StockController do
  use BambooInterviewWeb, :controller

  alias BambooInterview.Stocks
  alias BambooInterview.Stocks.Stock
  alias BambooInterviewWeb.Validators.Stock, as: StockValidator

  action_fallback BambooInterviewWeb.FallbackController

  def index(conn, params) do
    with {:ok, validated_params} <- StockValidator.query_params_cast_and_validate(params),
         stocks <- Stocks.list_stocks(validated_params) do
      render(conn, :index, stocks: stocks)
    end
  end

  def create(conn, %{"category_id" => category_id} = params) do
    with {:ok, validated_params} <- StockValidator.cast_and_validate(params),
         {:ok, %Stock{} = stock} <- Stocks.create_stock(category_id, validated_params) do
      conn
      |> put_status(:created)
      |> render(:show, stock: stock)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, stock} <- Stocks.get_stock(id) do
      render(conn, :show, stock: stock)
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, validated_params} <- StockValidator.cast_and_validate(params),
         {:ok, %Stock{} = stock} <- Stocks.update_stock(id, validated_params) do
      render(conn, :show, stock: stock)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Stock{}} <- Stocks.delete_stock(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
