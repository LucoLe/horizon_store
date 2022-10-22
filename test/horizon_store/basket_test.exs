defmodule HorizonStore.BasketTest do
  use ExUnit.Case, async: true
  alias HorizonStore.{Basket, Product}

  setup do
    [
      basket: %Basket{},
      voucher: Product.find_by(code: "VOUCHER"),
      t_shirt: Product.find_by(code: "TSHIRT")
    ]
  end

  describe "add_product/2" do
    test "adds product to the basket", %{basket: basket, voucher: voucher} do
      assert Basket.add_product(basket, voucher) == %Basket{products: %{voucher => 1}}
    end

    test "updates basket by adding a different product", %{
      basket: basket,
      voucher: voucher,
      t_shirt: t_shirt
    } do
      expected = %Basket{products: %{voucher => 1, t_shirt => 1}}

      basket =
        basket
        |> Basket.add_product(voucher)
        |> Basket.add_product(t_shirt)

      assert basket == expected
    end

    test "increments product quantity", %{basket: basket, voucher: voucher} do
      basket =
        basket
        |> Basket.add_product(voucher)
        |> Basket.add_product(voucher)

      assert basket.products[voucher] == 2
    end
  end
end
