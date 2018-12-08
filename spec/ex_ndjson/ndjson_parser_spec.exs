defmodule ExNdjson.NdJSONParserSpec do
  @moduledoc false

  use ESpec
  alias ExNdjson.NdJSONParser

  describe "parse/1" do
    context "Checks if iodata is valid/invalid NDJSON" do
      it "yields :valid format" do
        expect(NdJSONParser.parse([<<123, 125>>, 10, "1", 10]))
        |> to(eql({:valid, [%{}, 1]}))
      end

      it "yields :invalid format" do
        expected =
          {:invalid,
           [
             {1, {:error, %Jason.DecodeError{data: "{", position: 1, token: nil}}},
             {2, {:error, %Jason.DecodeError{data: "}", position: 0, token: nil}}},
             {3, {:error, %Jason.DecodeError{data: "[", position: 1, token: nil}}}
           ]}

        expect(NdJSONParser.parse([<<123>>, 10, <<125>>, 10, 91, <<13, 10>>]))
        |> to(eql(expected))
      end
    end
  end
end
