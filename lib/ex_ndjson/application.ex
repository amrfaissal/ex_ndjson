defmodule ExNdjson.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [ExNdjson.Worker]

    opts = [strategy: :one_for_one, name: ExNdjson.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
