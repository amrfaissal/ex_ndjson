defmodule ExNdjson do
  @moduledoc """
  Implements encoding and decoding of NDJSON as defined in [NDJSON Spec](https://github.com/ndjson/ndjson-spec).
  """

  @worker ExNdjson.Worker

  @type t :: nil | true | false | list | float | integer | String.t() | map

  @doc """
  Returns the NDJSON encoding of v, raises an exception on error.

  ## Examples

      iex> ExNdjson.marshal!([%{id: 1}, [1, 2, 3]])
      "{\"id\": \"1\"}\\n[1, 2, 3]\\n"
  """
  @spec marshal!([t()]) :: String.t() | no_return()
  def marshal!(v) when is_list(v), do: GenServer.call(@worker, {:marshal!, v})

  @doc """
  Parses the NDJSON-encoded data and returns a list of decoded JSON values.

  ## Examples

      iex> ExNdjson.unmarshal('{"id": "1"}\\n[1, 2, 3]\\r\\n')
      [%{"id" => "1"}, [1, 2, 3]]
  """
  @spec unmarshal(iodata()) :: [t()]
  def unmarshal(v), do: GenServer.call(@worker, {:unmarshal, v})

  @doc """
  Parses the NDJSON-encoded lines in the given path and returns a list of decoded JSON values.
  Raises an exception if failed to open the file.
  ## Examples

      iex> ExNdjson.unmarshal_from_file!("./fixtures/file.txt")
      [%{"id" => "1"}, [1, 2, 3]]
  """
  @spec unmarshal_from_file!(Path.t()) :: [t()] | no_return()
  def unmarshal_from_file!(path), do: GenServer.call(@worker, {:unmarshal_from_file, path})
end
