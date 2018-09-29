defmodule ExNdjson.NdJSONParserSpec do
  @moduledoc false

  use ESpec
  alias ExNdjson.NdJSONParser

  describe "parse/1" do
    context "Checks if iodata is valid NDJSON" do
      it(
        do:
          expect(
            [<<123, 125>>, 10, "1", 10]
            |> NdJSONParser.parse()
            |> to(eql({:valid, [%{}, 1]}))
          )
      )

      it(
        do:
          expect(
            [<<123>>, 10, <<125>>, 10, 91, <<13, 10>>]
            |> NdJSONParser.parse()
            |> to(
              eql(
                {:invalid,
                 [
                   {1, {:error, :invalid, 1}},
                   {2, {:error, {:invalid, "}", 0}}},
                   {3, {:error, :invalid, 1}}
                 ]}
              )
            )
          )
      )
    end
  end
end
