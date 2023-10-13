defmodule BambooInterview.StocksTest do
  use BambooInterview.DataCase

  alias BambooInterview.Stocks
  alias BambooInterview.Stocks.{CompanyCategories, Stock, UserStockCategory}

  import BambooInterview.StocksFixtures
  import BambooInterview.UserFixtures

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
      [company_category | _] =
        Enum.map(1..4, fn _count -> company_categories_fixture() end)

      assert Stocks.get_company_category(company_category.id) == {:ok, company_category}
    end

    test "error: returns not found when given a non existent id" do
      Enum.map(1..4, fn _count -> company_categories_fixture() end)
      non_existent_id = Ecto.UUID.generate()
      assert Stocks.get_company_category(non_existent_id) == {:error, :not_found}
    end
  end

  describe "create_company_category/1" do
    test "success: create a company_category when given valid params" do
      valid_params = company_category_validator()

      assert {:ok, %CompanyCategories{} = company_category} =
               Stocks.create_company_category(valid_params)

      assert company_category.name == valid_params.name
    end

    test "error: returns not found when given a non existent id" do
      invalid_attrs = %{company_category_validator() | name: nil}
      assert {:error, %Ecto.Changeset{}} = Stocks.create_company_category(invalid_attrs)
    end
  end

  describe "update_company_category/2" do
    test "success: updates a company_category when given valid params" do
      [company_category | _] =
        Enum.map(1..4, fn _count -> company_categories_fixture() end)

      valid_params = company_category_validator()

      assert {:ok, %CompanyCategories{} = returned_company_category} =
               Stocks.update_company_category(company_category.id, valid_params)

      assert returned_company_category.name == valid_params.name
    end

    test "error: returns not found when given a non existent id" do
      Enum.map(1..4, fn _count -> company_categories_fixture() end)
      valid_params = company_category_validator()
      non_existent_id = Ecto.UUID.generate()
      assert {:error, :not_found} = Stocks.update_company_category(non_existent_id, valid_params)
    end

    test "error: returns validation error when given a invalid params" do
      [company_category | _] =
        Enum.map(1..4, fn _count -> company_categories_fixture() end)

      invalid_params = %{company_category_validator() | name: nil}

      assert {:error, %Ecto.Changeset{}} =
               Stocks.update_company_category(company_category.id, invalid_params)
    end
  end

  describe "delete_company_category/1" do
    test "success: deletes a company_category when given a valid id" do
      [company_category | _] =
        Enum.map(1..4, fn _count -> company_categories_fixture() end)

      assert {:ok, %CompanyCategories{} = _returned_company_category} =
               Stocks.delete_company_category(company_category.id)

      assert Stocks.get_company_category(company_category.id) == {:error, :not_found}
    end

    test "error: returns not found when given a non existent id" do
      Enum.map(1..4, fn _count -> company_categories_fixture() end)
      non_existent_id = Ecto.UUID.generate()
      assert {:error, :not_found} = Stocks.delete_company_category(non_existent_id)
    end
  end

  # stocks 

  describe "list_stocks/0" do
    test "success: returns all stocks" do
      category = company_categories_fixture()
      stock = stock_fixture(category)
      filter_params = invalid_stock_validator()
      assert [returned_stock | _] = Stocks.list_stocks(filter_params)
      assert returned_stock.id == stock.id
    end

    test "success: returns empty data when stock exist" do
      filter_params = invalid_stock_validator()
      assert Stocks.list_stocks(filter_params) == []
    end

    test "success: returns all stocks by company_category_id" do
      category = company_categories_fixture()
      Enum.map(1..4, fn _count -> stock_fixture(category) end)
      decoy_category = company_categories_fixture()
      Enum.map([1, 2, 3, 5], fn _count -> stock_fixture(decoy_category) end)

      filter_params = invalid_stock_validator()
      assert returned_stocks = Stocks.list_stocks(%{filter_params | category_id: category.id})
      assert length(returned_stocks) == 4
    end
  end

  describe "get_stock/1" do
    test "success: returns the stocks with given id" do
      category = company_categories_fixture()
      [stock_entry | _] = Enum.map(1..4, fn _count -> stock_fixture(category) end)
      assert {:ok, %Stock{} = stock} = Stocks.get_stock(stock_entry.id)
      assert stock.id == stock_entry.id
      assert stock.company_category_id == category.id
    end

    test "error: returns not found when given a non existent id" do
      category = company_categories_fixture()
      Enum.map(1..4, fn _count -> stock_fixture(category) end)
      non_existent_id = Ecto.UUID.generate()
      assert Stocks.get_stock(non_existent_id) == {:error, :not_found}
    end
  end

  describe "create_stock/2" do
    test "success: create a create_stock when given valid params" do
      category = company_categories_fixture()
      valid_params = stock_validator()
      assert {:ok, %Stock{} = stock} = Stocks.create_stock(category.id, valid_params)
      assert stock.name == valid_params.name
    end

    test "error: returns not found when given a non existent id" do
      category = company_categories_fixture()
      invalid_attrs = %{stock_validator() | name: nil}
      assert {:error, %Ecto.Changeset{}} = Stocks.create_stock(category.id, invalid_attrs)
    end
  end

  describe "update_stock/2" do
    test "success: updates a stock when given valid params" do
      category = company_categories_fixture()
      [stock | _] = Enum.map(1..4, fn _count -> stock_fixture(category) end)
      valid_params = stock_validator()
      assert {:ok, %Stock{} = returned_stock} = Stocks.update_stock(stock.id, valid_params)
      assert returned_stock.name == valid_params.name
    end

    test "error: returns not found when given a non existent id" do
      category = company_categories_fixture()
      Enum.map(1..4, fn _count -> stock_fixture(category) end)
      valid_params = stock_validator()
      non_existent_id = Ecto.UUID.generate()
      assert {:error, :not_found} = Stocks.update_stock(non_existent_id, valid_params)
    end

    test "error: returns validation error when given a invalid params" do
      category = company_categories_fixture()
      [stock | _] = Enum.map(1..4, fn _count -> stock_fixture(category) end)
      invalid_params = %{stock_validator() | name: nil}
      assert {:error, %Ecto.Changeset{}} = Stocks.update_stock(stock.id, invalid_params)
    end
  end

  describe "delete_stock/1" do
    test "success: deletes a stock when given a valid id" do
      category = company_categories_fixture()
      [stock | _] = Enum.map(1..4, fn _count -> stock_fixture(category) end)
      assert {:ok, %Stock{} = _returned_stock} = Stocks.delete_stock(stock.id)

      assert Stocks.get_stock(stock.id) == {:error, :not_found}
    end

    test "error: returns not found when given a non existent id" do
      category = company_categories_fixture()
      Enum.map(1..4, fn _count -> stock_fixture(category) end)
      non_existent_id = Ecto.UUID.generate()
      assert {:error, :not_found} = Stocks.delete_stock(non_existent_id)
    end
  end

  # user stocks category

  describe "list_user_stock_categories/2" do
    test "success: returns all user company categories" do
      user_stock_category = user_stock_category_fixture()
      assert [returned_user_stock_category | _] = Stocks.list_user_stock_categories()
      assert returned_user_stock_category.id == user_stock_category.id
      assert returned_user_stock_category.user_id == user_stock_category.user_id

      assert returned_user_stock_category.company_category_id ==
               user_stock_category.company_category_id
    end

    test "success: returns empty data when user company categories exist" do
      assert Stocks.list_user_stock_categories() == []
    end
  end

  describe "get_user_stock_category/1" do
    test "success: returns the user company categories with given id" do
      [user_stock_category | _] =
        Enum.map(1..4, fn _count -> user_stock_category_fixture() end)

      assert {:ok, %UserStockCategory{} = returned_user_stock_category} =
               Stocks.get_user_stock_category(user_stock_category.id)

      assert returned_user_stock_category.id == user_stock_category.id

      assert returned_user_stock_category.company_category_id ==
               user_stock_category.company_category_id
    end

    test "error: returns not found when given a non existent id" do
      Enum.map(1..4, fn _count -> user_stock_category_fixture() end)
      non_existent_id = Ecto.UUID.generate()
      assert Stocks.get_user_stock_category(non_existent_id) == {:error, :not_found}
    end
  end

  describe "create_user_stock_category/2" do
    test "success: create a user company categoru when given valid params" do
      category = company_categories_fixture()
      user = users_fixture()

      assert {:ok, %UserStockCategory{} = returned_user_stock_category} =
               Stocks.create_user_stock_category(user, category.id)

      assert returned_user_stock_category.user_id == user.id
      assert returned_user_stock_category.company_category_id == category.id
    end
  end

  describe "delete_user_stock_category/1" do
    test "success: deletes a user_stock_category when given a valid id" do
      [user_stock_category | _] =
        Enum.map(1..4, fn _count -> user_stock_category_fixture() end)

      assert {:ok, %UserStockCategory{} = _returned_user_stock_category} =
               Stocks.delete_user_stock_category(user_stock_category.id)

      assert Stocks.get_user_stock_category(user_stock_category.id) == {:error, :not_found}
    end

    test "error: returns not found when given a non existent id" do
      Enum.map(1..4, fn _count -> user_stock_category_fixture() end)
      non_existent_id = Ecto.UUID.generate()
      assert {:error, :not_found} = Stocks.delete_user_stock_category(non_existent_id)
    end
  end
end
