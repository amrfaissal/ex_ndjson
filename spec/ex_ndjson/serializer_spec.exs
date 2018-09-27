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

          expect(
            buffer
            |> is_pid()
            |> to(be_true())
          )

          expect(
            buffer
            |> Agent.get(fn state -> state end)
            |> to(eql([["[{\"version\":\"1.7\",\"name\":\"elixir\"},[2,4,6]]", "\n"]]))
          )

          expect(
            buffer
            |> Agent.stop()
            |> to(eql(:ok))
          )
        end
      end

      context "Given a chunk of non supported type" do
        it "Raises an exception" do
          buffer = start()

          expect(fn ->
            buffer
            |> write!({2, 4, 6})
          end)
          |> to(raise_exception(ExNdjson.SerializeError))

          expect(
            buffer
            |> Agent.stop()
            |> to(eql(:ok))
          )
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

          expect(
            output
            |> to(eql("[{\"version\":\"1.7\",\"name\":\"elixir\"},[2,4,6]]\n"))
          )
        end
      end
    end
  end
end
