defmodule Xarb.ShoppinglistTest do
  use Xarb.DataCase

  alias Xarb.Shoppinglist

  describe "lists" do
    alias Xarb.Shoppinglist.List

    @valid_attrs %{finished: true, titel: "some titel"}
    @update_attrs %{finished: false, titel: "some updated titel"}
    @invalid_attrs %{finished: nil, titel: nil}

    def list_fixture(attrs \\ %{}) do
      {:ok, list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shoppinglist.create_list()

      list
    end

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Shoppinglist.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Shoppinglist.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      assert {:ok, %List{} = list} = Shoppinglist.create_list(@valid_attrs)
      assert list.finished == true
      assert list.titel == "some titel"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shoppinglist.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      assert {:ok, %List{} = list} = Shoppinglist.update_list(list, @update_attrs)
      assert list.finished == false
      assert list.titel == "some updated titel"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Shoppinglist.update_list(list, @invalid_attrs)
      assert list == Shoppinglist.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Shoppinglist.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Shoppinglist.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Shoppinglist.change_list(list)
    end
  end

  describe "list_ingredients" do
    alias Xarb.Shoppinglist.List_ingredient

    @valid_attrs %{amount: 120.5, measurement: "some measurement", name: "some name"}
    @update_attrs %{amount: 456.7, measurement: "some updated measurement", name: "some updated name"}
    @invalid_attrs %{amount: nil, measurement: nil, name: nil}

    def list_ingredient_fixture(attrs \\ %{}) do
      {:ok, list_ingredient} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shoppinglist.create_list_ingredient()

      list_ingredient
    end

    test "list_list_ingredients/0 returns all list_ingredients" do
      list_ingredient = list_ingredient_fixture()
      assert Shoppinglist.list_list_ingredients() == [list_ingredient]
    end

    test "get_list_ingredient!/1 returns the list_ingredient with given id" do
      list_ingredient = list_ingredient_fixture()
      assert Shoppinglist.get_list_ingredient!(list_ingredient.id) == list_ingredient
    end

    test "create_list_ingredient/1 with valid data creates a list_ingredient" do
      assert {:ok, %List_ingredient{} = list_ingredient} = Shoppinglist.create_list_ingredient(@valid_attrs)
      assert list_ingredient.amount == 120.5
      assert list_ingredient.measurement == "some measurement"
      assert list_ingredient.name == "some name"
    end

    test "create_list_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shoppinglist.create_list_ingredient(@invalid_attrs)
    end

    test "update_list_ingredient/2 with valid data updates the list_ingredient" do
      list_ingredient = list_ingredient_fixture()
      assert {:ok, %List_ingredient{} = list_ingredient} = Shoppinglist.update_list_ingredient(list_ingredient, @update_attrs)
      assert list_ingredient.amount == 456.7
      assert list_ingredient.measurement == "some updated measurement"
      assert list_ingredient.name == "some updated name"
    end

    test "update_list_ingredient/2 with invalid data returns error changeset" do
      list_ingredient = list_ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Shoppinglist.update_list_ingredient(list_ingredient, @invalid_attrs)
      assert list_ingredient == Shoppinglist.get_list_ingredient!(list_ingredient.id)
    end

    test "delete_list_ingredient/1 deletes the list_ingredient" do
      list_ingredient = list_ingredient_fixture()
      assert {:ok, %List_ingredient{}} = Shoppinglist.delete_list_ingredient(list_ingredient)
      assert_raise Ecto.NoResultsError, fn -> Shoppinglist.get_list_ingredient!(list_ingredient.id) end
    end

    test "change_list_ingredient/1 returns a list_ingredient changeset" do
      list_ingredient = list_ingredient_fixture()
      assert %Ecto.Changeset{} = Shoppinglist.change_list_ingredient(list_ingredient)
    end
  end
end
