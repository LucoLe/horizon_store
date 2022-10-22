defmodule HorizonStore.Checkout do
  alias HorizonStore.{Basket, Product}

  @two_for_one_products ["VOUCHER"]
  @bulk_purchase_products %{"TSHIRT" => %{quantity: 3, discount_price: 19.0}}
  @bulk_purchase_product_codes Map.keys(@bulk_purchase_products)

  @spec scan(Basket.t(), String.t()) :: Basket.t()
  def scan(%Basket{} = basket, code) do
    with %Product{} = product <- Product.find_by(code: code) do
      Basket.add_product(basket, product)
    else
      _ -> basket
    end
  end

  @spec total(Basket.t()) :: String.t()
  def total(%Basket{products: products}) do
    currency_sign =
      products
      |> Map.keys()
      |> List.last()
      |> Map.get(:currency_sign)

    products
    |> Enum.reduce(0, fn row, total -> total + sub_total(row) end)
    |> format_total(currency_sign)
  end

  @spec sub_total({Product.t(), integer()}) :: float()
  defp sub_total({product, quantity}) do
    apply_discount(product, quantity)
    |> Tuple.product()
  end

  @spec apply_discount(Product.t(), integer()) :: {integer(), float()}
  defp apply_discount(%Product{code: code, price: price}, quantity)
       when code in @two_for_one_products do
    quantity = div(quantity, 2) + rem(quantity, 2)

    {quantity, price}
  end

  defp apply_discount(%Product{code: code, price: price}, quantity)
       when code in @bulk_purchase_product_codes do
    price =
      if quantity >= @bulk_purchase_products[code][:quantity] do
        @bulk_purchase_products[code][:discount_price]
      else
        price
      end

    {quantity, price}
  end

  defp apply_discount(%Product{price: price}, quantity), do: {quantity, price}

  @spec format_total(float(), String.t()) :: String.t()
  defp format_total(total, currency_sign) do
    "#{:erlang.float_to_binary(total, decimals: 2)}#{currency_sign}"
  end
end
