defmodule BambooInterviewWeb.UserJSON do
  alias BambooInterview.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def auth(%{user: user, token: token}) do
    %{data: data(user), token: token}
  end

  @doc """
  Renders a token.
  """
  def user_token(%{token: token}) do
    %{
      data: %{
        token: token
      }
    }
  end

  def data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      role: user.role,
      is_active: user.is_active,
      last_name: user.last_name,
      first_name: user.first_name,
      gender: user.gender,
      deleted_at: user.deleted_at
    }
  end
end
