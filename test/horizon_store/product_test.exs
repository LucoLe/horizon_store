defmodule HorizonStore.ProductTest do
  use ExUnit.Case, async: true
  alias HorizonStore.Product

  describe "find_by/1" do
    test "returns a product from state" do
      assert %Product{code: "VOUCHER"} = Product.find_by(code: "VOUCHER")
    end

    test "returns nil for unknown product code" do
      assert Product.find_by(code: "a") == nil
    end
  end
end
