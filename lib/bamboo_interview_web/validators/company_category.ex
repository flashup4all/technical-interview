defmodule BambooInterviewWeb.Validators.CompanyCategory do
  @moduledoc false
  use BambooInterview.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @required_fields [:name]

  @cast_fields @required_fields ++ [:description]

  @primary_key false
  embedded_schema do
    field :name, :string
    field :description, :string
  end

  def cast_and_validate(params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end
end
