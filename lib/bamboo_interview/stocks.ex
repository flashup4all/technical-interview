defmodule BambooInterview.Stocks do
  @moduledoc """
  The Stocks context.
  """

  import Ecto.Query, warn: false

  alias BambooInterview.Stocks.{CompanyCategories, Stock, UserStockCategory}
  alias BambooInterview.Accounts.User

  alias BambooInterviewWeb.Validators.CompanyCategory, as: CompanyCategoryValidator
  alias BambooInterviewWeb.Validators.Stock, as: StockValidator
  alias BambooInterview.EmailService

  def create_company_category(%CompanyCategoryValidator{} = params) do
    CompanyCategories.create_company_categories(Map.from_struct(params))
  end

  def get_company_category(id) do
    CompanyCategories.get_company_categories(id)
  end

  def list_company_categories() do
    CompanyCategories.list_company_categories()
  end

  def update_company_category(id, %CompanyCategoryValidator{} = params) do
    with {:ok, %CompanyCategories{} = company_category} <-
           CompanyCategories.get_company_categories(id),
         {:ok, %CompanyCategories{} = company_category} <-
           CompanyCategories.update_company_categories(company_category, Map.from_struct(params)) do
      {:ok, company_category}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  def delete_company_category(id) do
    with {:ok, %CompanyCategories{} = company_category} <-
           CompanyCategories.get_company_categories(id),
         {:ok, %CompanyCategories{} = company_category} <-
           CompanyCategories.delete_company_categories(company_category) do
      {:ok, company_category}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  # stocks
  def create_stock(category_id, %StockValidator{} = params) do
    with {:ok, %CompanyCategories{} = company_category} <-
           CompanyCategories.get_company_categories(category_id),
         {:ok, %Stock{} = stock} <- Stock.create_stock(company_category, Map.from_struct(params)) do
      # send notifications to users in the same company stock category about newly added stock
      users = User.get_users_by_stock_category(stock)

      #  improve this to use Oban to enable DB tracking, logging and retries
      Task.start(fn ->
        Enum.each(users, fn user ->
          # publish notification to subscribe users about new listed stocks
          BambooInterviewWeb.Endpoint.broadcast("stocks:listed_stocks", "new_category_stock", %{
            stock_category_name: company_category.name,
            stock_name: stock.name,
            country: stock.country,
            stock_exchange_type: stock.stock_exchange_type,
            symbol: stock.symbol
          })

          # send email notification to subscribe users about new listed stocks
          EmailService.deliver_new_listed_stock_email(user, stock)
        end)
      end)

      {:ok, stock}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  def get_stock(id) do
    Stock.get_stock(id)
  end

  def list_stocks(params) do
    Stock.list_stocks(params)
  end

  def update_stock(id, %StockValidator{} = params) do
    with {:ok, %Stock{} = stock} <- Stock.get_stock(id),
         {:ok, %Stock{} = stock} <- Stock.update_stock(stock, Map.from_struct(params)) do
      {:ok, stock}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  def delete_stock(id) do
    with {:ok, %Stock{} = stock} <- Stock.get_stock(id),
         {:ok, %Stock{} = stock} <- Stock.delete_stock(stock) do
      {:ok, stock}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  # this is should be an api call, but i am mocking a generated data
  def get_newly_listed_stocks() do
    stocks =
      Enum.map(1..2, fn _ ->
        %{
          "country" => Faker.Address.country(),
          "name" => Faker.Company.name(),
          "stockExchange" => Enum.random(["NASDAQ", "NSE", "SSE"]),
          "symbol" => Faker.Company.bullshit_prefix(),
          "category" => Faker.Industry.industry()
        }
      end)

    Phoenix.PubSub.broadcast(BambooInterview.PubSub, "newly_listed_stocks", stocks)
    stocks
  end

  # user stock category
  def create_user_stock_category(%User{} = user, category_id) do
    with {:ok, %CompanyCategories{} = company_category} <-
           CompanyCategories.get_company_categories(category_id),
         {:ok, %UserStockCategory{} = user_stock_category} <-
           UserStockCategory.create_user_stock_category(user, company_category) do
      {:ok, user_stock_category}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  def get_user_stock_category(id) do
    UserStockCategory.get_user_stock_category(id)
  end

  # def list_user_stock_categories(category_id) do
  #   UserStockCategory.list_user_stock_category(category_id)
  # end

  def list_user_stock_categories() do
    UserStockCategory.list_user_stock_category()
  end

  def delete_user_stock_category(id) do
    with {:ok, %UserStockCategory{} = user_stock_category} <-
           UserStockCategory.get_user_stock_category(id),
         {:ok, %UserStockCategory{} = user_stock_category} <-
           UserStockCategory.delete_user_stock_category(user_stock_category) do
      {:ok, user_stock_category}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end
end
