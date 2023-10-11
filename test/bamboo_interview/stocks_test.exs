defmodule BambooInterview.StocksTest do
  use BambooInterview.DataCase

  alias BambooInterview.Stocks
  alias BambooInterview.Stocks.CompanyCategories

  import BambooInterview.StocksFixtures

  describe "list_company_categories/0" do
    test "success: returns all company_categories" do
      company_categories = company_categories_fixture()
      assert Stocks.list_company_categories() == [company_categories]
    end

    test "success: returns empty data when company_categories exist" do
      assert Stocks.list_company_categories() == []
    end
  end

  describe "get_company_category/1" do
    test "success: returns the company_category with given id" do
      [company_category | _] = Enum.map([1, 2, 3, 4], fn _count -> company_categories_fixture() end)
      assert Stocks.get_company_category(company_category.id) == {:ok, company_category}
    end

    test "error: returns not found when given a non existent id" do
      Enum.map([1, 2, 3, 4], fn _count -> company_categories_fixture() end)
      non_existent_id = Ecto.UUID.generate()
      assert Stocks.get_company_category(non_existent_id) == {:error, :not_found}
    end
  end

  describe "create_company_category/1" do
    test "success: create a company_category when given valid params" do
      valid_params = company_category_validator()
      assert  {:ok, %CompanyCategories{} = company_category} = Stocks.create_company_category(valid_params)
      assert company_category.name == valid_params.name
    end

    test "error: returns not found when given a non existent id" do
      invalid_attrs = %{company_category_validator() | name: nil}
      assert {:error, %Ecto.Changeset{}} = Stocks.create_company_category(invalid_attrs)
    end
  end

  describe "update_company_category/2" do
    test "success: updates a company_category when given valid params" do
      [company_category | _] = Enum.map([1, 2, 3, 4], fn _count -> company_categories_fixture() end)
      valid_params = company_category_validator()
      assert  {:ok, %CompanyCategories{} = returned_company_category} = Stocks.update_company_category(company_category.id, valid_params)
      assert returned_company_category.name == valid_params.name
    end

    test "error: returns not found when given a non existent id" do
      Enum.map([1, 2, 3, 4], fn _count -> company_categories_fixture() end)
      valid_params = company_category_validator()
      non_existent_id = Ecto.UUID.generate()
      assert {:error, :not_found} = Stocks.update_company_category(non_existent_id, valid_params)
    end

    test "error: returns validation error when given a invalid params" do
      [company_category | _] = Enum.map([1, 2, 3, 4], fn _count -> company_categories_fixture() end)
      invalid_params = %{company_category_validator() | name: nil}
      assert {:error, %Ecto.Changeset{}} = Stocks.update_company_category(company_category.id, invalid_params)
    end
  end

  describe "delete_company_category/2" do
    test "success: deletes a company_category when given a valid id" do
      [company_category | _] = Enum.map([1, 2, 3, 4], fn _count -> company_categories_fixture() end)
      assert  {:ok, %CompanyCategories{} = _returned_company_category} = Stocks.delete_company_category(company_category.id)

      assert Stocks.get_company_category(company_category.id) == {:error, :not_found}
    end

    test "error: returns not found when given a non existent id" do
      Enum.map([1, 2, 3, 4], fn _count -> company_categories_fixture() end)
      non_existent_id = Ecto.UUID.generate()
      assert {:error, :not_found} = Stocks.delete_company_category(non_existent_id)
    end
  end
end
