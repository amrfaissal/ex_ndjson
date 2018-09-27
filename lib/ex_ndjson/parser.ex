defmodule ExNdjson.Parser do
  @moduledoc false
  @type t :: nil | true | false | list | float | integer | String.t() | map

  @callback parse(String.t()) :: {:ok, t()} | {:error, :invalid, map}
end

defmodule ExNdjson.JSONParser do
  @moduledoc """
  Implements ExNdjson.Parser behaviour for JSON binaries.
  """
  @behaviour ExNdjson.Parser

  def parse(payload), do: Poison.Parser.parse(payload)
end

defmodule ExNdjson.NdJSONParser do
  @moduledoc """
  Implements ExNdjson.Parser behaviour for NDJSON binaries.
  """
  @behaviour ExNdjson.Parser

  alias ExNdjson.Helpers

  def parse(payload) do
    parsed_lines =
      payload
      |> String.trim()
      |> String.split(["\r\n", "\n"])
      |> Enum.map(&Poison.decode/1)

    case parsed_lines |> Enum.filter(fn line -> match?({:error, _, _}, line) end) do
      [] ->
        {:ok, payload}

      _ ->
        {:error, :invalid,
         parsed_lines
         |> Helpers.to_indexed_map()
         |> Enum.filter(fn {_, error} -> match?({:error, _, _}, error) end)}
    end
  end
end
