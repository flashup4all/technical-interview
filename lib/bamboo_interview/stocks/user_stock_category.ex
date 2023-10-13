defmodule BambooInterview.Stocks.UserStockCategory do
  @moduledoc false
  use BambooInterview.Schema
  alias BambooInterview.Repo

  alias BambooInterview.Stocks.CompanyCategories

  alias BambooInterview.Accounts.User

  @type t :: %__MODULE__{}

  schema "user_stock_category" do
    belongs_to(:user, User)
    belongs_to(:company_category, CompanyCategories)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @doc false
  def changeset(%User{} = user, %CompanyCategories{} = company_category) do
    %__MODULE__{}
    |> cast(%{}, [:user_id, :company_category_id])
    |> validate_required([])
    |> unique_constraint(:company_category_id, name: "category already added")
    |> put_assoc(:company_category, company_category)
    |> put_assoc(:user, user)
  end

  @doc """
  Returns the list of user_stock_category.

  ## Examples

      iex> list_user_stock_category()
      [%__MODULE__{}, ...]

  """
  def list_user_stock_category do
    Repo.all(__MODULE__)
  end

  @doc """
  Gets a single user_stock_category.

  Raises `Ecto.NoResultsError` if the User stock category does not exist.

  ## Examples

      iex> get_user_stock_category(123)
      %__MODULE__{}

      iex> get_user_stock_category(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_stock_category(id) do
    case Repo.get(__MODULE__, id) do
      %__MODULE__{} = stock -> {:ok, stock}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Creates a user_stock_category.

  ## Examples

      iex> create_user_stock_category(%{field: value})
      {:ok, %__MODULE__{}}

      iex> create_user_stock_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_stock_category(%User{} = user, %CompanyCategories{} = company_category) do
    changeset(user, company_category)
    |> Repo.insert()
  end

  @doc """
  Deletes a user_stock_category.

  ## Examples

      iex> delete_user_stock_category(user_stock_category)
      {:ok, %__MODULE__{}}

      iex> delete_user_stock_category(user_stock_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_stock_category(%__MODULE__{} = user_stock_category) do
    Repo.delete(user_stock_category)
  end
end
