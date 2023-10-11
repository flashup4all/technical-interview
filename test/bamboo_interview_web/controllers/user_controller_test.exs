defmodule BambooInterviewWeb.UserControllerTest do
  use BambooInterviewWeb.ConnCase

  import BambooInterview.UserFixtures

  
  @invalid_attrs %{first_name: nil, last_name: nil, email: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create/2" do
    test "renders user when given params is valid", %{conn: conn} do
        %{first_name: first_name} = payload = Map.from_struct(user_validator())
      conn = post(conn, ~p"/api/users", payload)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "first_name" => ^first_name,
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show/2" do
    test "renders user data when given valid user id", %{conn: conn} do
        [user | _] = Enum.map([1, 2, 3, 4], fn _count -> users_fixture() end)


      conn = get(conn, ~p"/api/users/#{user.id}")  
      data = json_response(conn, 200)["data"]

               assert data["id"] == user.id
               assert data["first_name"] == user.first_name
    end

    test "returns errors when user id is non existent", %{conn: conn} do
        non_existent_id = Ecto.UUID.generate()
        conn = get(conn, ~p"/api/users/#{non_existent_id}")  
       assert json_response(conn, 404)["errors"] != %{}
    end
  end
end
