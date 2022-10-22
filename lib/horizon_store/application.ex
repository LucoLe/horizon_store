defmodule HorizonStore.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HorizonStore.Product
    ]

    opts = [strategy: :one_for_all, name: HorizonStore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
