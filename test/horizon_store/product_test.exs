defmodule HorizonStore.ProductTest do
  use ExUnit.Case, async: true
  alias HorizonStore.Product

  describe "find_by_code/1" do
    test "returns product" do
      assert %Product{} = Product.find_by_code("VOUCHER")
    end

    test "returns nil for unknown product code" do
      assert Product.find_by_code("a") == nil
    end
  end

  describe "all/0" do
    test "returns all products" do
      assert Enum.all?(Product.all(), fn product -> %Product{} = product end)
    end
  end
end
