defmodule BambooInterviewWeb.Validators.User do
  @moduledoc false
  use BambooInterview.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @required_fields [:first_name, :last_name, :email, :password]

  @cast_fields @required_fields ++ [:gender]

  @primary_key false
  embedded_schema do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string
    field :gender, Ecto.Enum, values: [:male, :female, :non_binary, :others, :prefer_not_to_say]
  end

  def cast_and_validate(params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end

  def cast_and_validate_auth_params(params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required([:email, :password])
    |> apply_changes_if_valid()
  end
end
