defmodule BambooInterviewWeb.CompanyCategoriesJSON do
  alias BambooInterview.Stocks.CompanyCategories

  @doc """
  Renders a list of company_categories.
  """
  def index(%{company_categories: company_categories}) do
    %{data: for(company_categories <- company_categories, do: data(company_categories))}
  end

  @doc """
  Renders a single company_categories.
  """
  def show(%{company_categories: company_categories}) do
    %{data: data(company_categories)}
  end

  defp data(%CompanyCategories{} = company_categories) do
    %{
      id: company_categories.id,
      name: company_categories.name,
      description: company_categories.description
    }
  end
end
