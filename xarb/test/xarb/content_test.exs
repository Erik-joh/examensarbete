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
end
