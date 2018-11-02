defmodule ExNdjson.SerializeError do
  defexception message: "serialization error", exception: nil
end

defmodule ExNdjson.Serializer do
  @moduledoc """
  Serializes data structures to NDJSON format.
  """
  use Agent
  alias ExNdjson.SerializeError

  @type t :: nil | true | false | list | float | integer | String.t() | map

  defmacrop stacktrace do
    if Version.compare(System.version(), "1.7.0") != :lt do
      quote do: __STACKTRACE__
    else
      quote do: System.stacktrace()
    end
  end

  @spec start() :: pid()
  def start, do: start_buffer([])

  @spec write!(pid(), t()) :: pid() | no_return()
  def write!(buffer, chunk) do
    put_buffer(buffer, [chunk |> Poison.encode!(), "\n"])
    buffer
  rescue
    e -> reraise SerializeError, [exception: e], stacktrace()
  end

  @spec serialize(pid()) :: String.t() | no_return()
  def serialize(buffer) do
    result =
      buffer
      |> Agent.get(& &1)
      |> Enum.reverse()
      |> IO.iodata_to_binary()
      |> cleanup_string()

    :ok = stop_buffer(buffer)
    result
  end

  defp start_buffer(state) do
    {:ok, pid} = Agent.start_link(fn -> state end)
    pid
  end

  defp stop_buffer(buffer), do: Agent.stop(buffer)
  defp put_buffer(buffer, content), do: Agent.update(buffer, &[content | &1])

  defp cleanup_string(string) do
    string
    |> String.replace(~r/\\\\/, "")
    |> String.replace(~r/"{/, "{")
    |> String.replace(~r/}"/, "}")
  end
end
