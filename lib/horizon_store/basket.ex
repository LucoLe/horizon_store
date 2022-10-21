defmodule HorizonStore.Basket do
  alias HorizonStore.{Basket, Product}
  @type t :: %__MODULE__{products: %{Product.t() => integer()}}

  defstruct products: %{}

  @spec add_product(Basket.t(), Product.t()) :: Basket.t()
  def add_product(%Basket{} = basket, %Product{} = product) do
    basket
    |> Map.update!(:products, fn products -> Map.update(products, product, 1, &(&1 + 1)) end)
  end
end
