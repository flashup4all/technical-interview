defmodule BambooInterview.StocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BambooInterview.Stocks` context.
  """
  alias BambooInterviewWeb.Validators.CompanyCategory
  alias BambooInterviewWeb.Validators.Stock, as: StockValidator
  import BambooInterview.UserFixtures

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
      description: "some description"
    }
  end

  @doc """
  Generate a stock.
  """
  def stock_fixture(category, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        country: Faker.Address.country(),
        name: Faker.Company.name(),
        # stock_exchange_type can be a seperate model
        stock_exchange_type: Enum.random(["NASDAQ", "NSE", "SSE"]),
        symbol: "some symbol"
      })

    {:ok, stock} = BambooInterview.Stocks.Stock.create_stock(category, attrs)

    stock
  end

  def stock_validator do
    %StockValidator{
      country: Faker.Address.country(),
      name: Faker.Company.name(),
      # this can be a seperate model
      stock_exchange_type: Enum.random(["NASDAQ", "NSE", "SSE"]),
      symbol: "some symbol"
    }
  end

  def invalid_stock_validator do
    %StockValidator{
      country: nil,
      name: nil,
      stock_exchange_type: nil,
      symbol: nil
    }
  end

  @doc """
  Generate a user_stock_category.
  """
  def user_stock_category_fixture() do
    category = company_categories_fixture()
    user = users_fixture()

    {:ok, user_stock_category} =
      BambooInterview.Stocks.UserStockCategory.create_user_stock_category(user, category)

    user_stock_category
  end
end
