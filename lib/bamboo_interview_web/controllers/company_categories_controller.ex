defmodule BambooInterviewWeb.CompanyCategoriesController do
  use BambooInterviewWeb, :controller

  alias BambooInterview.Stocks
  alias BambooInterview.Stocks.CompanyCategories
  alias BambooInterviewWeb.Validators.CompanyCategory, as: CompanyCategoryValidator

  action_fallback BambooInterviewWeb.FallbackController

  def index(conn, _params) do
    company_categories = Stocks.list_company_categories()
    render(conn, :index, company_categories: company_categories)
  end

  def create(conn, params) do
    with {:ok, validated_params} <- CompanyCategoryValidator.cast_and_validate(params),
    {:ok, %CompanyCategories{} = company_categories} <- Stocks.create_company_category(validated_params) do
      conn
      |> put_status(:created)
      |> render(:show, company_categories: company_categories)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, company_categories} <- Stocks.get_company_category(id) do
      render(conn, :show, company_categories: company_categories)
     end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, validated_params} <- CompanyCategoryValidator.cast_and_validate(params),
    {:ok, %CompanyCategories{} = company_categories} <- Stocks.update_company_category(id, validated_params) do
      render(conn, :show, company_categories: company_categories)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %CompanyCategories{}} <- Stocks.delete_company_category(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
