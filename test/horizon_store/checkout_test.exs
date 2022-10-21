defmodule HorizonStore.CheckoutTest do
  use ExUnit.Case, async: true
  alias HorizonStore.{Checkout, Basket, Product}

  setup do
    [
      basket: %Basket{},
      voucher: Product.find_by_code("VOUCHER"),
      t_shirt: Product.find_by_code("TSHIRT"),
      mug: Product.find_by_code("MUG")
    ]
  end

  describe "scan/2" do
    test "adds product to the basket", %{basket: basket, voucher: voucher} do
      assert Checkout.scan(basket, "VOUCHER") == %Basket{products: %{voucher => 1}}
    end

    test "updates basket by adding a different product", %{
      basket: basket,
      voucher: voucher,
      t_shirt: t_shirt
    } do
      expected = %Basket{products: %{voucher => 1, t_shirt => 1}}

      basket =
        basket
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("TSHIRT")

      assert basket == expected
    end

    test "increments product quantity", %{basket: basket, voucher: voucher} do
      basket =
        basket
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("VOUCHER")

      assert basket.products[voucher] == 2
    end

    test "handles unknown products", %{basket: basket} do
      new_basket =
        basket
        |> Checkout.scan("a")

      assert basket == new_basket
    end
  end

  describe "total/0" do
    test "calculates total", %{basket: basket} do
      total =
        basket
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("TSHIRT")
        |> Checkout.total()

      assert total == "25.00€"
    end

    test "applies two for one discount", %{basket: basket} do
      total =
        basket
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("VOUCHER")
        |> Checkout.total()

      assert total == "10.00€"
    end

    test "applies bulk purchase discount", %{basket: basket} do
      total =
        basket
        |> Checkout.scan("TSHIRT")
        |> Checkout.scan("TSHIRT")
        |> Checkout.scan("TSHIRT")
        |> Checkout.total()

      assert total == "57.00€"
    end

    # I'd delete this test. I used it while developing and I'd usually delete this test once I'm done iterating.
    # I'm leaving here for now because it might help the review process.
    test "calculates totals", %{basket: basket} do
      total =
        basket
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("TSHIRT")
        |> Checkout.scan("MUG")
        |> Checkout.total()

      assert total == "32.50€"

      total =
        basket
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("TSHIRT")
        |> Checkout.scan("VOUCHER")
        |> Checkout.total()

      assert total == "25.00€"

      total =
        basket
        |> Checkout.scan("TSHIRT")
        |> Checkout.scan("TSHIRT")
        |> Checkout.scan("TSHIRT")
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("TSHIRT")
        |> Checkout.total()

      assert total == "81.00€"

      total =
        basket
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("TSHIRT")
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("VOUCHER")
        |> Checkout.scan("MUG")
        |> Checkout.scan("TSHIRT")
        |> Checkout.scan("TSHIRT")
        |> Checkout.total()

      assert total == "74.50€"
    end
  end
end
