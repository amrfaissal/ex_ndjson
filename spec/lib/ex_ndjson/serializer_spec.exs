defmodule ExNdjson.SerializerSpec do
  @moduledoc false

  use ESpec
  use Agent
  alias ExNdjson.Serializer

  before do
    {:shared, buffer: Serializer.start()}
  end

  example_group do
    describe "write/2" do
      context "Given a binary chunk" do
        it "writes the chunk to the buffer and appends a newline to it" do
          buffer =
            shared.buffer
            |> Serializer.write("{}")

          expect(
            buffer
            |> is_pid()
            |> to(be_true())
          )

          expect(buffer |> to(eql(shared.buffer)))

          expect(
            Agent.get(buffer, fn state -> state end)
            |> to(eql([["{}", "\n"]]))
          )
        end
      end
    end

    describe "serialize/1" do
      context "Given the buffer's pid" do
        it "returns a binary in NDJSON format" do
        end
      end
    end
  end
end
