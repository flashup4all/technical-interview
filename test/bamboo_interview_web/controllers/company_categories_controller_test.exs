defmodule BambooInterviewWeb.CompanyCategoriesControllerTest do
  use BambooInterviewWeb.ConnCase

  import BambooInterview.StocksFixtures

  alias BambooInterview.Stocks.CompanyCategories

  
  @invalid_attrs %{description: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index/2" do
    test "lists all company_categories", %{conn: conn} do
        Enum.map([1, 2, 3, 4], fn _count -> company_categories_fixture() end)
        conn = get(conn, ~p"/api/company_categories")
        data = json_response(conn, 200)["data"]
        assert !is_nil(data)
        assert length(data) == 4
      end

    test "returns empty list when company_categories has not saved data", %{conn: conn} do
      conn = get(conn, ~p"/api/company_categories")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create/2" do
    test "renders company_categories when data is valid", %{conn: conn} do
        %{name: name} = payload = Map.from_struct(company_category_validator())
      conn = post(conn, ~p"/api/company_categories", payload)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/company_categories/#{id}")

      assert %{
               "id" => ^id,
               "name" => ^name
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/company_categories", company_categories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update/2" do
    setup [:create_company_categories]

    test "renders company_categories when data is valid", %{conn: conn, company_categories: %CompanyCategories{id: id}} do
       %{name: name} = params = Map.from_struct(company_category_validator())

      conn = put(conn, ~p"/api/company_categories/#{id}", params)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/company_categories/#{id}")

      assert %{
               "id" => ^id,
               "name" => ^name
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, company_categories: company_categories} do
      conn = put(conn, ~p"/api/company_categories/#{company_categories}", company_categories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete/2" do
    setup [:create_company_categories]

    test "deletes chosen company_categories", %{conn: conn, company_categories: company_categories} do
      conn = delete(conn, ~p"/api/company_categories/#{company_categories}")
      assert response(conn, 204)
    end
  end

  defp create_company_categories(_) do
    company_categories = company_categories_fixture()
    %{company_categories: company_categories}
  end
end
