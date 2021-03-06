defmodule ExNdjson.Worker do
  @moduledoc """
  Worker which handles encoding and decoding of NDJSON.
  """

  use GenServer
  import ExNdjson.Serializer
  alias ExNdjson.NdJSONParser

  def start_link, do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  def init(:ok), do: {:ok, []}

  def handle_call({:marshal!, v}, _from, state) do
    pid = start()

    v
    |> Stream.each(fn record -> pid |> write!(record) end)
    |> Stream.run()

    {:reply, serialize(pid), state}
  end

  def handle_call({:marshal_into_file!, v, path}, _from, state) do
    pid = start()

    v
    |> Stream.each(fn record -> pid |> write!(record) end)
    |> Stream.run()

    result = serialize(pid)

    {:reply, path |> dump_to_file!(result), state}
  end

  def handle_call({:unmarshal, v}, _from, state) do
    result =
      case NdJSONParser.parse(v) do
        {:valid, decoded} -> decoded
        error -> error
      end

    {:reply, result, state}
  end

  def handle_call({:unmarshal_from_file!, path}, _from, state) do
    lines =
      path
      |> File.stream!()
      |> Enum.to_list()

    result =
      case NdJSONParser.parse(lines) do
        {:valid, decoded} -> decoded
        error -> error
      end

    {:reply, result, state}
  end

  #
  # Helpers
  #

  defp dump_to_file!(path, content) do
    file = File.open!(path, [:write])
    IO.binwrite(file, content)
    File.close(file)
  end
end
