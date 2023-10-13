defmodule BambooInterviewWeb.StockControllerTest do
  use BambooInterviewWeb.ConnCase

  import BambooInterview.StocksFixtures
  import BambooInterview.UserFixtures

  alias BambooInterview.Stocks.Stock
  alias BambooInterviewWeb.Auth.Guardian

  @update_params %{
    country: "some updated country",
    name: "some updated name",
    stock_exchange_type: "some updated stock_exchange_type",
    symbol: "some updated symbol"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup %{conn: conn} do
    user = users_fixture()

    {:ok, token, _claims} = Guardian.encode_and_sign(user, token_type: "auth")

    conn_with_token =
      conn
      |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn_with_token: conn_with_token, user: user}
  end

  describe "index" do
    test "lists empty  data when no stocks exist", %{conn_with_token: conn} do
      category = company_categories_fixture()
      conn = get(conn, ~p"/api/categories/#{category.id}/stocks")
      assert json_response(conn, 200)["data"] == []
    end

    test "lists company category all stocks", %{conn_with_token: conn} do
      category = company_categories_fixture()
      stocks = Enum.map(1..4, fn _count -> stock_fixture(category) end)
      decoy_category = company_categories_fixture()
      _decoy_stocks = Enum.map(1..4, fn _count -> stock_fixture(decoy_category) end)
      inserted_stocks_ids = Enum.map(stocks, & &1.id)

      conn = get(conn, ~p"/api/categories/#{category.id}/stocks")
      assert returned_response = json_response(conn, 200)["data"]
      assert length(returned_response) == 4

      for stock <- returned_response do
        assert Enum.member?(inserted_stocks_ids, stock["id"])
        assert stock["company_category_id"] == category.id
      end
    end

    test "lists all stocks", %{conn_with_token: conn} do
      category = company_categories_fixture()
      Enum.map(1..4, fn _count -> stock_fixture(category) end)
      decoy_category = company_categories_fixture()
      _decoy_stocks = Enum.map(1..4, fn _count -> stock_fixture(decoy_category) end)

      conn = get(conn, ~p"/api/categories/stocks")
      assert returned_response = json_response(conn, 200)["data"]
      assert length(returned_response) == 8
    end

    test "lists all stocks by their stock_exchange_type", %{conn_with_token: conn} do
      category = company_categories_fixture()
      Enum.map(1..4, fn _count -> stock_fixture(category) end)
      decoy_category = company_categories_fixture()
      _decoy_stocks = Enum.map(1..4, fn _count -> stock_fixture(decoy_category) end)

      conn = get(conn, ~p"/api/categories/stocks?stock_exchange_type=NASDAQ")
      assert returned_response = json_response(conn, 200)["data"]
      for stock <- returned_response do
        assert stock["stock_exchange_type"] == "NASDAQ"
      end
    end
  end

  describe "create stock" do
    test "renders stock when data is valid", %{conn_with_token: conn} do
      category = company_categories_fixture()

      params = %{
        "country" => "some country",
        "name" => "some name",
        "stock_exchange_type" => "some stock_exchange_type",
        "symbol" => "some symbol"
      }

      conn = post(conn, ~p"/api/categories/#{category.id}/stocks", params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/categories/#{category.id}/stocks/#{id}")

      assert %{
               "id" => ^id,
               "country" => "some country",
               "name" => "some name",
               "stock_exchange_type" => "some stock_exchange_type",
               "symbol" => "some symbol"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn_with_token: conn} do
      category = company_categories_fixture()
      conn = post(conn, ~p"/api/categories/#{category.id}/stocks", %{})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update stock" do
    setup [:create_stock]

    test "renders stock when data is valid", %{
      conn_with_token: conn,
      stock: %Stock{id: id, company_category_id: company_category_id}
    } do
      conn = put(conn, ~p"/api/categories/#{company_category_id}/stocks/#{id}", @update_params)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/categories/#{company_category_id}/stocks/#{id}")

      assert %{
               "id" => ^id,
               "country" => "some updated country",
               "name" => "some updated name",
               "stock_exchange_type" => "some updated stock_exchange_type",
               "symbol" => "some updated symbol"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn_with_token: conn,
      stock: %Stock{id: id, company_category_id: company_category_id}
    } do
      conn = put(conn, ~p"/api/categories/#{company_category_id}/stocks/#{id}", %{})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete stock" do
    setup [:create_stock]

    test "deletes chosen stock", %{
      conn_with_token: conn,
      stock: %Stock{id: id, company_category_id: company_category_id}
    } do
      conn = delete(conn, ~p"/api/categories/#{company_category_id}/stocks/#{id}")
      assert response(conn, 204)
    end
  end

  defp create_stock(_) do
    category = company_categories_fixture()
    stock = stock_fixture(category)
    %{stock: stock, category: category}
  end
end
