defmodule BambooInterview.UserFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BambooInterview.Accounts.User` context.
  """
  alias BambooInterviewWeb.Validators.User

  @doc """
  Generate a create_user.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        first_name: Faker.Person.first_name(),
        last_name: Faker.Person.last_name(),
        email: Faker.Internet.email(),
        gender: Enum.random([:male, :female, :non_binary, :others, :prefer_not_to_say]),
        password: valid_password()
      })
      |> BambooInterview.Accounts.User.create_user()

    user
  end

  def user_validator do
    %User{
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      email: Faker.Internet.email(),
      gender: Enum.random([:male, :female, :non_binary, :others, :prefer_not_to_say]),
      password: valid_password()
    }
  end

  def valid_password, do: "Atestpassword2"
end
