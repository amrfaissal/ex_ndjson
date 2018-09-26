defmodule ExNdjson.Serializer do
  @moduledoc """
  Serializes data structures to NDJSON format.
  """
  use Agent
  alias ExNdjson.NdJSONParser

  @spec start() :: pid()
  def start, do: start_buffer([])

  @spec write(pid(), String.t()) :: pid()
  def write(buffer, chunk) when is_binary(chunk) do
    put_buffer(buffer, [chunk, "\n"])
    buffer
  end

  @spec serialize(pid()) :: String.t() | {:error, :invalid, %{}}
  def serialize(buffer) do
    result =
      buffer
      |> Agent.get(& &1)
      |> Enum.reverse()
      |> IO.iodata_to_binary()

    :ok = stop_buffer(buffer)

    case NdJSONParser.parse(result) do
      {:ok, payload} -> payload
      error -> error
    end
  end

  defp start_buffer(state) do
    {:ok, pid} = Agent.start_link(fn -> state end)
    pid
  end

  defp stop_buffer(buffer), do: Agent.stop(buffer)
  defp put_buffer(buffer, content), do: Agent.update(buffer, &[content | &1])
end
