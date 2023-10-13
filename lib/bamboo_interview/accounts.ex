defmodule BambooInterview.Accounts do
  @moduledoc false
  alias BambooInterviewWeb.Validators.User, as: UserValidator
  alias BambooInterview.Accounts.User
  alias BambooInterviewWeb.Auth.Guardian

  def create_user_account(%UserValidator{} = params) do
    with {:ok, %User{} = user} <- User.create_user(Map.from_struct(params)) do
      # setup oban job to send trigger send verification email
      {:ok, user}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  def get_user(id) do
    User.get_user(id)
  end

  def authenticate(email, password) do
    with {:ok, user} <- User.get_user_by_email(String.downcase(email)),
         {true, :verify_pass} <- {User.verify_password(user, password), :verify_pass},
         {:ok, token, _claims} <-
           Guardian.encode_and_sign(user, token_type: "auth") do
      {:ok, %{user: user, token: token}}
    else
      {false, :verify_pass} ->
        # Logger.warn("BambooInterview.Auth - failed to verify email/password")

        changeset =
          %User{}
          |> Ecto.Changeset.cast(_params = %{}, [:email, :password])
          |> Ecto.Changeset.add_error(:email, "email/password do not match")
          |> Ecto.Changeset.add_error(:password, "email/password do not match")

        {:error, changeset}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}

      {:error, :not_found} ->
        # Logger.warn("BambooInterview.Auth - User with email not found")
        {:error, :unauthorized}
    end
  end
end
