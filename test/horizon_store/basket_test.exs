defmodule HorizonStore.BasketTest do
  use ExUnit.Case, async: true
  alias HorizonStore.{Basket, Product}

  setup do
    [
      basket: %Basket{},
      products: Product.all()
    ]
  end

  describe "add_product/2" do
    test "adds product to the basket", %{basket: basket, products: [first_product | _]} do
      assert Basket.add_product(basket, first_product) == %Basket{products: %{first_product => 1}}
    end

    test "updates basket by adding a different product", %{
      basket: basket,
      products: [first_product, second_product, _]
    } do
      expected = %Basket{products: %{first_product => 1, second_product => 1}}

      basket =
        basket
        |> Basket.add_product(first_product)
        |> Basket.add_product(second_product)

      assert basket == expected
    end

    test "increments product quantity", %{basket: basket, products: [first_product | _]} do
      basket =
        basket
        |> Basket.add_product(first_product)
        |> Basket.add_product(first_product)

      assert basket.products[first_product] == 2
    end
  end
end
