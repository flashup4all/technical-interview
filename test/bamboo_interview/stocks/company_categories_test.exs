defmodule BambooInterview.CompanyCategoriesTest do
  use BambooInterview.DataCase

  alias BambooInterview.Stocks.CompanyCategories

  describe "company_categories" do
    alias BambooInterview.Stocks.CompanyCategories

    import BambooInterview.StocksFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_company_categories/0 returns all company_categories" do
      company_categories = company_categories_fixture()
      assert CompanyCategories.list_company_categories() == [company_categories]
    end

    test "get_company_categories/1 returns the company_categories with given id" do
      company_categories = company_categories_fixture()

      assert CompanyCategories.get_company_categories(company_categories.id) ==
               {:ok, company_categories}
    end

    test "create_company_categories/1 with valid data creates a company_categories" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %CompanyCategories{} = company_categories} =
               CompanyCategories.create_company_categories(valid_attrs)

      assert company_categories.description == "some description"
      assert company_categories.name == "some name"
    end

    test "create_company_categories/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               CompanyCategories.create_company_categories(@invalid_attrs)
    end

    test "update_company_categories/2 with valid data updates the company_categories" do
      company_categories = company_categories_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %CompanyCategories{} = company_categories} =
               CompanyCategories.update_company_categories(company_categories, update_attrs)

      assert company_categories.description == "some updated description"
      assert company_categories.name == "some updated name"
    end

    test "update_company_categories/2 with invalid data returns error changeset" do
      company_categories = company_categories_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CompanyCategories.update_company_categories(company_categories, @invalid_attrs)

      assert {:ok, company_categories} ==
               CompanyCategories.get_company_categories(company_categories.id)
    end

    test "delete_company_categories/1 deletes the company_categories" do
      company_categories = company_categories_fixture()

      assert {:ok, %CompanyCategories{}} =
               CompanyCategories.delete_company_categories(company_categories)

      assert {:error, :not_found} ==
               CompanyCategories.get_company_categories(company_categories.id)
    end
  end
end
