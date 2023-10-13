defmodule BambooInterview.Stocks.Stock do
  @moduledoc false
  use BambooInterview.Schema
  alias BambooInterview.Repo

  alias BambooInterview.Stocks.CompanyCategories
  import BambooInterview.Utils.DynamicFilter

  @type t :: %__MODULE__{}

  schema "stocks" do
    field :country, :string
    field :name, :string
    field :stock_exchange_type, :string
    field :symbol, :string

    belongs_to(:company_category, CompanyCategories)
    timestamps()
  end

  @required_fields [:name, :symbol, :country, :stock_exchange_type]
  @cast_fields [] ++ @required_fields

  def fields, do: __MODULE__.__schema__(:fields)
  @doc false
  def changeset(%CompanyCategories{} = company_category, attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:company_category, company_category)
  end

  @doc """
  Returns the list of stocks.

  ## Examples

      iex> list_stocks()
      [%__MODULE__{}, ...]

  """

  def list_stocks(query_params) do
    query =
      __MODULE__
      |> filter(:country, :eq, query_params.country)
      |> filter(:name, :eq, query_params.name)
      |> filter(:stock_exchange_type, :eq, query_params.stock_exchange_type)
      |> filter(:symbol, :eq, query_params.symbol)
      |> filter(:company_category_id, :eq, query_params.category_id)

    Repo.all(query)
  end

  @doc """
  Gets a single stock.

  Returns {:error, :not_found}` if the Stock does not exist.

  ## Examples

      iex> get_stock(123)
      %__MODULE__{}

      iex> get_stock(456)
      ** {:error, :not_found}

  """
  def get_stock(id) do
    case Repo.get(__MODULE__, id) do
      %__MODULE__{} = stock -> {:ok, stock}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Creates a stock.

  ## Examples

      iex> create_stock(%{field: value})
      {:ok, %Stock{}}

      iex> create_stock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stock(%CompanyCategories{} = company_category, params) do
    changeset(company_category, params)
    |> Repo.insert()
  end

  @doc """
  Updates a stock.

  ## Examples

      iex> update_stock(stock, %{field: new_value})
      {:ok, %__MODULE__{}}

      iex> update_stock(stock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stock(%__MODULE__{} = stock, update_params) do
    stock
    |> cast(update_params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end

  @doc """
  Deletes a stock.

  ## Examples

      iex> delete_stock(stock)
      {:ok, %__MODULE__{}}

      iex> delete_stock(stock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock(%__MODULE__{} = stock) do
    Repo.delete(stock)
  end
end
