defmodule BambooInterview.Stocks do
  @moduledoc """
  The Stocks context.
  """

  import Ecto.Query, warn: false
  alias BambooInterview.Repo

  alias BambooInterview.Stocks.CompanyCategories
  alias BambooInterviewWeb.Validators.CompanyCategory, as: CompanyCategoryValidator

  def create_company_category(%CompanyCategoryValidator{} = params) do
    with {:ok, %CompanyCategories{} = company_category} <- CompanyCategories.create_company_categories(Map.from_struct(params)) do

      {:ok, company_category}
    else
        {:error, error} -> {:error, error}
        error -> {:error, error}
    end
  end

  def get_company_category(id) do
    CompanyCategories.get_company_categories(id)
  end

  def list_company_categories() do
    CompanyCategories.list_company_categories()
  end

  def update_company_category(id, %CompanyCategoryValidator{} = params) do
    with {:ok, %CompanyCategories{} = company_category} <- CompanyCategories.get_company_categories(id),
    {:ok, %CompanyCategories{} = company_category} <- CompanyCategories.update_company_categories(company_category, Map.from_struct(params)) do

      {:ok, company_category}
    else
        {:error, error} -> {:error, error}
        error -> {:error, error}
    end
  end

  def delete_company_category(id) do
    with {:ok, %CompanyCategories{} = company_category} <- CompanyCategories.get_company_categories(id),
    {:ok, %CompanyCategories{} = company_category} <- CompanyCategories.delete_company_categories(company_category) do

      {:ok, company_category}
    else
        {:error, error} -> {:error, error}
        error -> {:error, error}
    end
  end
end
