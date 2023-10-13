defmodule BambooInterviewWeb.CompanyCategoriesControllerTest do
  use BambooInterviewWeb.ConnCase

  import BambooInterview.StocksFixtures
  import BambooInterview.UserFixtures

  alias BambooInterview.Stocks.CompanyCategories
  alias BambooInterviewWeb.Auth.Guardian

  @invalid_attrs %{description: nil, name: nil}

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

  describe "index/2" do
    test "lists all company categories", %{conn_with_token: conn} do
      Enum.map([1, 2, 3, 4], fn _count -> company_categories_fixture() end)
      conn = get(conn, ~p"/api/company-categories")
      data = json_response(conn, 200)["data"]
      assert !is_nil(data)
      assert length(data) == 4
    end

    test "returns empty list when company_categories has not saved data", %{conn_with_token: conn} do
      conn = get(conn, ~p"/api/company-categories")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create/2" do
    test "renders company_categories when data is valid", %{conn_with_token: conn} do
      %{name: name} = payload = Map.from_struct(company_category_validator())
      conn = post(conn, ~p"/api/company-categories", payload)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/company-categories/#{id}")

      assert %{
               "id" => ^id,
               "name" => ^name
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn_with_token: conn} do
      conn = post(conn, ~p"/api/company-categories", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update/2" do
    setup [:create_company_categories]

    test "renders company_categories when data is valid", %{
      conn_with_token: conn,
      company_categories: %CompanyCategories{id: id}
    } do
      %{name: name} = params = Map.from_struct(company_category_validator())

      conn = put(conn, ~p"/api/company-categories/#{id}", params)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/company-categories/#{id}")

      assert %{
               "id" => ^id,
               "name" => ^name
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn_with_token: conn,
      company_categories: company_categories
    } do
      conn =
        put(conn, ~p"/api/company-categories/#{company_categories.id}",
          company_categories: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete/2" do
    setup [:create_company_categories]

    test "deletes chosen company categories", %{
      conn_with_token: conn,
      company_categories: company_categories
    } do
      conn = delete(conn, ~p"/api/company-categories/#{company_categories}")
      assert response(conn, 204)
    end
  end

  defp create_company_categories(_) do
    company_categories = company_categories_fixture()
    %{company_categories: company_categories}
  end
end
