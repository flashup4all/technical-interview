defmodule BambooInterview.Schema do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import BambooInterview.Schema
      import Ecto.Changeset

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts type: :utc_datetime_usec
    end
  end

  @spec apply_changes_if_valid(Ecto.Changeset.t()) :: {:error, Ecto.Changeset.t()} | {:ok, map()}

  def apply_changes_if_valid(%{valid?: true} = changeset),
    do: {:ok, Ecto.Changeset.apply_changes(changeset)}

  def apply_changes_if_valid(changeset),
    do: {:error, changeset}
end
