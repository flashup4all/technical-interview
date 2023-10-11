defmodule BambooInterview.Accounts do
  @moduledoc false
  alias BambooInterviewWeb.Validators.User, as: UserValidator
  alias BambooInterview.Accounts.User

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
end
