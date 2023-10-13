defmodule BambooInterview.Accounts.User do
  @moduledoc false
  use BambooInterview.Schema
  alias BambooInterview.Repo
  import Ecto.Query
  alias BambooInterview.Stocks.UserStockCategory

  @type t :: %__MODULE__{}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :gender, Ecto.Enum, values: [:male, :female, :non_binary, :others, :prefer_not_to_say]
    field :role, Ecto.Enum, values: [:admin, :user], default: :user

    field :password, :string, virtual: true
    field :password_hash, :binary
    field :is_active, :boolean, default: true
    field :deleted_at, :utc_datetime_usec

    many_to_many :category, BambooInterview.Stocks.CompanyCategories,
      join_through: BambooInterview.Stocks.UserStockCategory,
      on_replace: :delete

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:first_name, :last_name, :email, :password]

  @cast_fields @required_fields ++ [:gender, :role, :deleted_at]

  defp changeset(params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> update_change(:email, &String.downcase(&1 || ""))
    |> validate_format(
      :email,
      ~r/^[\w.!#$%&'*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i
    )
    |> validate_password()
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    |> hash_password()
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    if password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:password_hash, Argon2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  def create_user(params) do
    changeset(params)
    |> Repo.insert()
  end

  def get_user(id) do
    case Repo.get(__MODULE__, id) do
      %__MODULE__{} = user -> {:ok, user}
      nil -> {:error, :not_found}
    end
  end

  def get_user_by_email(email) do
    case Repo.get_by(__MODULE__, email: email) do
      %__MODULE__{} = user -> {:ok, user}
      nil -> {:error, :not_found}
    end
  end

  def verify_password(%__MODULE__{} = user, password) do
    Argon2.verify_pass(password, user.password_hash)
  end

  def get_users_by_stock_category(stock) do
    __MODULE__
    |> join(:inner, [user], user_category in UserStockCategory,
      on: user.id == user_category.user_id
    )
    |> where(
      [user, user_category],
      user_category.company_category_id == ^stock.company_category_id
    )
    |> Repo.all()
  end
end
