defmodule BambooInterviewWeb.UserControllerTest do
  use BambooInterviewWeb.ConnCase

  alias BambooInterviewWeb.Auth.Guardian

  import BambooInterview.UserFixtures

  @invalid_attrs %{first_name: nil, last_name: nil, email: nil, password: nil}

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

  describe "create/2" do
    test "renders user when given params is valid", %{conn_with_token: conn} do
      %{first_name: first_name} = payload = Map.from_struct(user_validator())
      conn = post(conn, ~p"/api/users", payload)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "first_name" => ^first_name
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show/2" do
    test "renders user data when given valid user id", %{conn_with_token: conn, user: user} do
      Enum.map(1..4, fn _count -> users_fixture() end)

      conn = get(conn, ~p"/api/users/#{user.id}")
      data = json_response(conn, 200)["data"]

      assert data["id"] == user.id
      assert data["first_name"] == user.first_name
    end

    test "returns errors when user id is non existent", %{conn_with_token: conn} do
      non_existent_id = Ecto.UUID.generate()
      conn = get(conn, ~p"/api/users/#{non_existent_id}")
      assert json_response(conn, 404)["errors"] != %{}
    end
  end

  describe "login/2" do
    test "authenticated a user when given valid params", %{conn: conn} do
      payload = Map.from_struct(user_validator())
      conn = post(conn, ~p"/api/users", payload)
      user_data = json_response(conn, 201)["data"]
      conn = post(conn, ~p"/api/auth/login", payload)
      data = json_response(conn, 200)["data"]

      assert data["id"] == user_data["id"]
      assert data["first_name"] == user_data["first_name"]
    end

    # test "returns errors when user id is non existent", %{conn: conn} do
    #   non_existent_id = Ecto.UUID.generate()
    #   conn = get(conn, ~p"/api/users/#{non_existent_id}")
    #   assert json_response(conn, 404)["errors"] != %{}
    # end
  end
end
