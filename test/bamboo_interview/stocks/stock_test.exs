defmodule BambooInterview.StockTest do
  use BambooInterview.DataCase

  alias BambooInterview.Stocks.Stock
  import BambooInterview.StocksFixtures

  @invalid_attrs %{country: nil, name: nil, stock_exchange_type: nil, symbol: nil}

  describe "stocks" do
    test "list_stocks/0 returns all stocks" do
      category = company_categories_fixture()
      stock = stock_fixture(category)
      filter_params = invalid_stock_validator()
      assert [returned_stock] = Stock.list_stocks(filter_params)
      assert returned_stock.id == stock.id
      assert returned_stock.company_category_id == stock.company_category_id
    end

    test "get_stock!/1 returns the stock with given id" do
      category = company_categories_fixture()
      stock = stock_fixture(category)
      assert {:ok, _stock} = Stock.get_stock(stock.id)
    end

    test "create_stock/2 with valid data creates a stock" do
      category = company_categories_fixture()

      valid_attrs = %{
        country: "some country",
        name: "some name",
        stock_exchange_type: "NSE",
        symbol: "some symbol"
      }

      assert {:ok, %Stock{} = stock} = Stock.create_stock(category, valid_attrs)
      assert stock.country == "some country"
      assert stock.name == "some name"
      assert stock.stock_exchange_type == "NSE"
      assert stock.symbol == "some symbol"
    end

    test "create_stock/2 with invalid data returns error changeset" do
      category = company_categories_fixture()
      assert {:error, %Ecto.Changeset{}} = Stock.create_stock(category, @invalid_attrs)
    end

    test "update_stock/2 with valid data updates the stock" do
      category = company_categories_fixture()
      stock = stock_fixture(category)

      update_attrs = %{
        country: "some updated country",
        name: "some updated name",
        stock_exchange_type: "some updated stock_exchange_type",
        symbol: "some updated symbol"
      }

      assert {:ok, %Stock{} = stock} = Stock.update_stock(stock, update_attrs)
      assert stock.country == "some updated country"
      assert stock.name == "some updated name"
      assert stock.stock_exchange_type == "some updated stock_exchange_type"
      assert stock.symbol == "some updated symbol"
    end

    test "update_stock/2 with invalid data returns error changeset" do
      category = company_categories_fixture()
      stock = stock_fixture(category)
      assert {:error, %Ecto.Changeset{}} = Stock.update_stock(stock, @invalid_attrs)
      assert {:ok, _stock} = Stock.get_stock(stock.id)
    end

    test "delete_stock/1 deletes the stock" do
      category = company_categories_fixture()
      stock = stock_fixture(category)
      assert {:ok, %Stock{}} = Stock.delete_stock(stock)
      assert {:error, :not_found} = Stock.get_stock(stock.id)
    end
  end
end
