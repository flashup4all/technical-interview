defmodule BambooInterviewWeb.UserController do
  use BambooInterviewWeb, :controller

  alias BambooInterviewWeb.Validators.User, as: UserValidator
  alias BambooInterview.Accounts.User
  alias BambooInterview.Accounts

  action_fallback BambooInterviewWeb.FallbackController

  def create(conn, params) do
    with {:ok, validated_params} <- UserValidator.cast_and_validate(params),
         {:ok, %User{} = user} <- Accounts.create_user_account(validated_params) do
      conn
      |> put_status(201)
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.get_user(id) do
      conn
      |> put_status(200)
      |> render(:show, user: user)
    end
  end

  def login(conn, params) do
    with {:ok, validated_params} <- UserValidator.cast_and_validate_auth_params(params),
         {:ok, %{user: user, token: token}} <-
           Accounts.authenticate(validated_params.email, validated_params.password) do
      conn
      |> put_status(200)
      |> render(:auth, user: user, token: token)
    end
  end
end
