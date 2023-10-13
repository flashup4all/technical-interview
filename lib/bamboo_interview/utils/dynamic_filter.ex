defmodule BambooInterview.Utils.DynamicFilter do
  @moduledoc """
    This module dynamic ecto query filter
    It can be used to expand queries
    more cases can be added eg. `like`, `ilike`, `assoc` etc
  """
  import Ecto.Query, warn: false

  def filter(query, _field_name, _operator, nil, nil), do: query

  def filter(query, _field_name, _operator, nil), do: query

  def filter(query, field_name, :eq, value) do
    where(query, [record], field(record, ^field_name) == ^value)
  end

  def filter(query, field_name, :neq, value) do
    where(query, [record], field(record, ^field_name) != ^value)
  end
end
