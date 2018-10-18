Code.require_file("../spec_helper.exs", __DIR__)

defmodule ExNdjsonSpec do
  @moduledoc false

  use ESpec
  import PathHelpers

  example_group do
    describe "marshal!/1" do
      context "Given a list of terms" do
        it "Returns NDJSON encoding of those terms" do
          expect(ExNdjson.marshal!([%{id: 1}, [1, 2, 3]]))
          |> to(eql("{\"id\":1}\n[1,2,3]\n"))
        end
      end
    end

    describe "unmarshal/1" do
      context "Given an NDJSON binary" do
        it "Returns list of decoded JSON values" do
          expect(ExNdjson.unmarshal('{"id": "1"}\n[1, 2, 3]\r\n'))
          |> to(eql([%{"id" => "1"}, [1, 2, 3]]))
        end
      end

      context "Given an invalid NDJSON binary" do
        it "Returns :invalid tuple with list of errors" do
          expect(ExNdjson.unmarshal('{"id": "1"}\n[1, 2, 3\r\n'))
          |> to(eq({:invalid, [{2, {:error, :invalid, 8}}]}))
        end
      end
    end

    describe "unmarshal_from_file!/1" do
      context "Given an NDJSON file" do
        it "Parses its content and returns list of decoded JSON values" do
          path = fixtures_path() <> "/file.ndjson"

          expect(ExNdjson.unmarshal_from_file!(path))
          |> to(eql([%{"id" => "1"}, [1, 2, 3]]))
        end
      end
    end
  end
end
