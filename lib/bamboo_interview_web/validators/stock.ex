defmodule BambooInterviewWeb.Validators.Stock do
  @moduledoc false
  use BambooInterview.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @required_fields [:country, :name, :stock_exchange_type, :symbol]

  @cast_fields @required_fields ++ [:category_id]

  @primary_key false
  embedded_schema do
    field :country, :string
    field :name, :string
    field :stock_exchange_type, :string
    field :symbol, :string
    field :category_id, Ecto.UUID
  end

  def cast_and_validate(params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end

  def query_params_cast_and_validate(params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> apply_changes_if_valid()
  end
end
