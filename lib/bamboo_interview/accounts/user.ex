defmodule BambooInterview.Accounts.User do
  @moduledoc false
  use BambooInterview.Schema
  alias BambooInterview.Repo

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

  @doc """
  Creates a user.

  ## Examples

    iex> create_user(%{field: value})
    {:ok, %User{}}

    iex> create_user(%{field: bad_value})
    {:error, %Ecto.Changeset{}}
  """
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
end
