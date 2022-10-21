defmodule HorizonStore.Product do
  @type t :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          price: float(),
          currency_sign: String.t()
        }

  defstruct [:code, :name, price: 0.0, currency_sign: "€"]

  alias HorizonStore.Product

  @spec find_by_code(String.t()) :: Product.t() | nil
  def find_by_code(code) do
    Product.all()
    |> Enum.find(fn product -> product.code == code end)
  end

  # FIXME: store this in a cache
  @spec all() :: [Product.t()] | []
  def all() do
    File.read!("priv/products.json")
    |> Jason.decode!(keys: :atoms)
    |> Enum.map(fn %{code: code, name: name, price: price} ->
      {price, sign} = Float.parse(price)
      %Product{code: code, name: name, price: price, currency_sign: sign}
    end)
  end
end
