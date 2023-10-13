defmodule BambooInterviewWeb.UserStockCategoryControllerTest do
  use BambooInterviewWeb.ConnCase

  import BambooInterview.StocksFixtures
  import BambooInterview.UserFixtures
  alias BambooInterviewWeb.Auth.Guardian

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
    test "lists all user_stock_category", %{conn_with_token: conn} do
      conn = get(conn, ~p"/api/user-stock-categories")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_stock_category" do
    test "renders user_stock_category when data is valid", %{conn_with_token: conn} do
      category = company_categories_fixture()
      user = users_fixture()

      params = %{
        user_id: user.id,
        company_category_id: category.id
      }

      conn = post(conn, ~p"/api/user-stock-categories", params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/user-stock-categories/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end
  end

  describe "delete user_stock_category" do
    setup [:create_user_stock_category]

    test "deletes chosen user_stock_category", %{
      conn_with_token: conn,
      user_stock_category: user_stock_category
    } do
      conn = delete(conn, ~p"/api/user-stock-categories/#{user_stock_category.id}")
      assert response(conn, 204)
    end
  end

  defp create_user_stock_category(_) do
    user_stock_category = user_stock_category_fixture()
    %{user_stock_category: user_stock_category}
  end
end
