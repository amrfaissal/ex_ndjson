defmodule PathHelpers do
  def fixtures_path do
    Path.expand("fixtures", __DIR__)
  end
end

ESpec.configure(fn _config -> nil end)
