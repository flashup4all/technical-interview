defmodule BambooInterview.UserStockCategoryTest do
  use BambooInterview.DataCase

  alias BambooInterview.Stocks.UserStockCategory
  import BambooInterview.UserFixtures
  import BambooInterview.StocksFixtures

  describe "user_stock_category" do
    test "list_user_stock_category/2 returns all user_stock_category" do
      user_stock_category = user_stock_category_fixture()
      assert [returned_user_stock_category] = UserStockCategory.list_user_stock_category()
      assert user_stock_category.id == returned_user_stock_category.id
      assert user_stock_category.user_id == returned_user_stock_category.user_id

      assert user_stock_category.company_category_id ==
               returned_user_stock_category.company_category_id
    end

    test "get_user_stock_category/1 returns the user_stock_category with given id" do
      user_stock_category = user_stock_category_fixture()

      assert {:ok, returned_user_stock_category} =
               UserStockCategory.get_user_stock_category(user_stock_category.id)

      assert user_stock_category.id == returned_user_stock_category.id
      assert user_stock_category.user_id == returned_user_stock_category.user_id

      assert user_stock_category.company_category_id ==
               returned_user_stock_category.company_category_id
    end

    test "create_user_stock_category/1 with valid data creates a user_stock_category" do
      category = company_categories_fixture()
      user = users_fixture()

      assert {:ok, %UserStockCategory{} = _user_stock_category} =
               UserStockCategory.create_user_stock_category(user, category)
    end

    test "delete_user_stock_category/1 deletes the user_stock_category" do
      user_stock_category = user_stock_category_fixture()

      assert {:ok, %UserStockCategory{}} =
               UserStockCategory.delete_user_stock_category(user_stock_category)

      assert {:error, :not_found} ==
               UserStockCategory.get_user_stock_category(user_stock_category.id)
    end
  end
end
