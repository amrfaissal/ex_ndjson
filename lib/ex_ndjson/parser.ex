defmodule ExNdjson.Parser do
  @moduledoc false
  @type t :: nil | true | false | list | float | integer | String.t() | map

  @callback parse(iodata()) :: {:valid, t()} | {:invalid, [tuple]}
end

defmodule ExNdjson.JSONParser do
  @moduledoc """
  Implements ExNdjson.Parser behaviour for JSON IO data.
  """
  @behaviour ExNdjson.Parser

  def parse(payload) do
    with {:ok, result} <- payload |> IO.iodata_to_binary() |> Jason.decode() do
      {:valid, result}
    else
      error -> {:invalid, error}
    end
  end
end

defmodule ExNdjson.NdJSONParser do
  @moduledoc """
  Implements ExNdjson.Parser behaviour for NDJSON IO data.
  """
  @behaviour ExNdjson.Parser

  alias ExNdjson.Helpers

  def parse(payload) do
    parsed_lines =
      payload
      |> IO.iodata_to_binary()
      |> String.trim()
      |> String.split(["\r\n", "\n"])
      |> Enum.map(&Jason.decode/1)

    case parsed_lines
         |> Enum.filter(fn line -> match?({:error, _}, line) || match?({:error, _, _}, line) end) do
      [] ->
        {:valid, parsed_lines |> Keyword.values()}

      _ ->
        {:invalid,
         parsed_lines
         |> Helpers.to_indexed_map()
         |> Enum.filter(fn {_, error} ->
           match?({:error, _}, error) || match?({:error, _, _}, error)
         end)}
    end
  end
end
