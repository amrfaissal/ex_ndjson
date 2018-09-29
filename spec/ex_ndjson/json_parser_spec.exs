defmodule ExNdjson.JSONParserSpec do
  @moduledoc false

  use ESpec
  alias ExNdjson.JSONParser

  describe "parse/1" do
    context "Checks if iodata is valid JSON" do
      it(
        do:
          expect(
            <<123, 125>>
            |> JSONParser.parse()
            |> to(eql({:valid, %{}}))
          )
      )
    end
  end
end
