defmodule ExNdjson.SerializerSpec do
  @moduledoc false

  use ESpec
  use Agent
  import ExNdjson.Serializer

  example_group do
    describe "write!/2" do
      context "Given a chunk of any supported type" do
        it "Encodes and writes the chunk to the buffer and appends a newline to it" do
          buffer =
            start()
            |> write!([%{name: "elixir", version: "1.7"}, [2, 4, 6]])

          expect(is_pid(buffer)) |> to(be_true())

          expect(Agent.get(buffer, fn state -> state end))
          |> to(eql([["[{\"name\":\"elixir\",\"version\":\"1.7\"},[2,4,6]]", "\n"]]))

          expect(Agent.stop(buffer)) |> to(eql(:ok))
        end
      end

      context "Given a chunk of non supported type" do
        it "Raises an exception" do
          buffer = start()

          expect(fn -> write!(buffer, {2, 4, 6}) end)
          |> to(raise_exception(ExNdjson.SerializeError))

          expect(Agent.stop(buffer)) |> to(eql(:ok))
        end
      end
    end

    describe "serialize/1" do
      context "Given any supported term" do
        it "serializes it to NDJSON format" do
          output =
            start()
            |> write!([%{name: "elixir", version: "1.7"}, [2, 4, 6]])
            |> serialize()

          expect(output)
          |> to(eql("[{\"name\":\"elixir\",\"version\":\"1.7\"},[2,4,6]]\n"))
        end
      end
    end
  end
end
