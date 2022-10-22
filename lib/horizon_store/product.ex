defmodule HorizonStore.Product do
  @type t :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          price: float(),
          currency_sign: String.t()
        }

  defstruct [:code, :name, price: 0.0, currency_sign: "€"]

  use Agent
  alias HorizonStore.Product

  def start_link(_opts) do
    Agent.start_link(__MODULE__, :load_products, [], name: __MODULE__)
  end

  @spec find_by([{atom(), String.t()}]) :: Product.t() | nil
  def find_by(code: code) do
    Agent.get(__MODULE__, __MODULE__, :find_by, [[code: code]])
  end

  @spec load_products() :: [Product.t()]
  def load_products() do
    File.read!("priv/products.json")
    |> Jason.decode!(keys: :atoms)
    |> Enum.reduce(%{}, fn %{code: code, name: name, price: price}, products ->
      {price, sign} = Float.parse(price)

      products
      |> Map.put_new(code, %Product{code: code, name: name, price: price, currency_sign: sign})
    end)
  end

  @spec find_by(%{String.t() => Product.t()}, [{atom(), String.t()}]) :: Product.t() | nil
  def find_by(products, code: code), do: Map.get(products, code)
end
