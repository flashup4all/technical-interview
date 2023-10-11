defmodule BambooInterview.Stocks.CompanyCategories do
  use BambooInterview.Schema
  alias BambooInterview.Repo

  schema "company_categories" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @required_fields [:name]
  @cast_fields [:description] ++ @required_fields

  def fields, do: __MODULE__.__schema__(:fields)

  @doc false
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end

  @doc """
  Creates a company_categories.

  ## Examples

      iex> create_company_categories(%{field: value})
      {:ok, %CompanyCategories{}}

      iex> create_company_categories(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company_categories(params) do
    changeset(params)
    |> Repo.insert()
  end

  @doc """
  Gets a single company_categories.

  Raises `Ecto.NoResultsError` if the Company categories does not exist.

  ## Examples

      iex> get_company_categories!(123)
      %CompanyCategories{}

      iex> get_company_categories!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company_categories(id) do
    case Repo.get(__MODULE__, id) do
      %__MODULE__{} = user -> {:ok, user}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Returns the list of company_categories.

  ## Examples

      iex> list_company_categories()
      [%CompanyCategories{}, ...]

  """
  def list_company_categories do
    Repo.all(__MODULE__)
  end


  @doc """
  Updates a company_categories.

  ## Examples

      iex> update_company_categories(company_categories, %{field: new_value})
      {:ok, %CompanyCategories{}}

      iex> update_company_categories(company_categories, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company_categories(%__MODULE__{} = company_categories, update_params) do
    company_categories
    |> cast(update_params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end

  @doc """
  Deletes a company_categories.

  ## Examples

      iex> delete_company_categories(company_categories)
      {:ok, %CompanyCategories{}}

      iex> delete_company_categories(company_categories)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company_categories(%__MODULE__{} = company_categories) do
    Repo.delete(company_categories)
  end
end
