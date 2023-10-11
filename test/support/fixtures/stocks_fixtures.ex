defmodule BambooInterview.StocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BambooInterview.Stocks` context.
  """
  alias BambooInterviewWeb.Validators.CompanyCategory

  @doc """
  Generate a company_categories.
  """
  def company_categories_fixture(attrs \\ %{}) do
    {:ok, company_categories} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: Faker.Industry.industry()
      })
      |> BambooInterview.Stocks.CompanyCategories.create_company_categories()

    company_categories
  end

  def company_category_validator do
    %CompanyCategory{
      name: Faker.Lorem.word(),
      description: "some description",
    }
  end
end
