defmodule ExNdjson.Helpers do
  @moduledoc """
  Set of helper functions.
  """

  @spec to_indexed_map([term()]) :: %{}
  def to_indexed_map(list) when is_list(list) do
    list
    |> Stream.with_index(1)
    |> Enum.reduce(%{}, fn {v, k}, acc -> Map.put(acc, k, v) end)
  end
end
