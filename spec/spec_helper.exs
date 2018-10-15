defmodule PathHelpers do
  def fixture_path do
    Path.expand("fixtures", __DIR__)
  end
end

ESpec.configure(fn _config -> nil end)
