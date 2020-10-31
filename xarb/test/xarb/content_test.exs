defmodule Xarb.ContentTest do
  use Xarb.DataCase

  alias Xarb.Content

  describe "recipes" do
    alias Xarb.Content.Recipe

    @valid_attrs %{instructions: "some instructions", source: "some source", title: "some title"}
    @update_attrs %{instructions: "some updated instructions", source: "some updated source", title: "some updated title"}
    @invalid_attrs %{instructions: nil, source: nil, title: nil}

    def recipe_fixture(attrs \\ %{}) do
      {:ok, recipe} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_recipe()

      recipe
    end

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Content.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Content.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Content.create_recipe(@valid_attrs)
      assert recipe.instructions == "some instructions"
      assert recipe.source == "some source"
      assert recipe.title == "some title"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{} = recipe} = Content.update_recipe(recipe, @update_attrs)
      assert recipe.instructions == "some updated instructions"
      assert recipe.source == "some updated source"
      assert recipe.title == "some updated title"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_recipe(recipe, @invalid_attrs)
      assert recipe == Content.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Content.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Content.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Content.change_recipe(recipe)
    end
  end

  describe "recipe_ingredients" do
    alias Xarb.Content.Recipe_ingredient

    @valid_attrs %{amount: 42, measurement: "some measurement", name: "some name"}
    @update_attrs %{amount: 43, measurement: "some updated measurement", name: "some updated name"}
    @invalid_attrs %{amount: nil, measurement: nil, name: nil}

    def recipe_ingredient_fixture(attrs \\ %{}) do
      {:ok, recipe_ingredient} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_recipe_ingredient()

      recipe_ingredient
    end

    test "list_recipe_ingredients/0 returns all recipe_ingredients" do
      recipe_ingredient = recipe_ingredient_fixture()
      assert Content.list_recipe_ingredients() == [recipe_ingredient]
    end

    test "get_recipe_ingredient!/1 returns the recipe_ingredient with given id" do
      recipe_ingredient = recipe_ingredient_fixture()
      assert Content.get_recipe_ingredient!(recipe_ingredient.id) == recipe_ingredient
    end

    test "create_recipe_ingredient/1 with valid data creates a recipe_ingredient" do
      assert {:ok, %Recipe_ingredient{} = recipe_ingredient} = Content.create_recipe_ingredient(@valid_attrs)
      assert recipe_ingredient.amount == 42
      assert recipe_ingredient.measurement == "some measurement"
      assert recipe_ingredient.name == "some name"
    end

    test "create_recipe_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_recipe_ingredient(@invalid_attrs)
    end

    test "update_recipe_ingredient/2 with valid data updates the recipe_ingredient" do
      recipe_ingredient = recipe_ingredient_fixture()
      assert {:ok, %Recipe_ingredient{} = recipe_ingredient} = Content.update_recipe_ingredient(recipe_ingredient, @update_attrs)
      assert recipe_ingredient.amount == 43
      assert recipe_ingredient.measurement == "some updated measurement"
      assert recipe_ingredient.name == "some updated name"
    end

    test "update_recipe_ingredient/2 with invalid data returns error changeset" do
      recipe_ingredient = recipe_ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_recipe_ingredient(recipe_ingredient, @invalid_attrs)
      assert recipe_ingredient == Content.get_recipe_ingredient!(recipe_ingredient.id)
    end

    test "delete_recipe_ingredient/1 deletes the recipe_ingredient" do
      recipe_ingredient = recipe_ingredient_fixture()
      assert {:ok, %Recipe_ingredient{}} = Content.delete_recipe_ingredient(recipe_ingredient)
      assert_raise Ecto.NoResultsError, fn -> Content.get_recipe_ingredient!(recipe_ingredient.id) end
    end

    test "change_recipe_ingredient/1 returns a recipe_ingredient changeset" do
      recipe_ingredient = recipe_ingredient_fixture()
      assert %Ecto.Changeset{} = Content.change_recipe_ingredient(recipe_ingredient)
    end
  end
end
