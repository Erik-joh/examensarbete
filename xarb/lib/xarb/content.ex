defmodule Xarb.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias Xarb.Repo

  alias Xarb.Content.{Recipe, Recipe_ingredient}

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes(user) do
    from(r in Recipe, where: [user_id: ^user.id], order_by: [asc: :id])
    |> Repo.all()
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(user, id) do
    Repo.get_by!(Recipe, user_id: user.id, id: id)
    |> Repo.preload(recipe_ingredients: from(ri in Recipe_ingredient, order_by: ri.id))
  end

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:recipes)
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{data: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    recipe
    |> Recipe.changeset(attrs)
  end



  @doc """
  Returns the list of recipe_ingredients.

  ## Examples

      iex> list_recipe_ingredients()
      [%Recipe_ingredient{}, ...]

  """
  def list_recipe_ingredients(recipe) do
    from(ri in Recipe_ingredient, where: [recipe_id: ^recipe.id], order_by: [asc: :id])
    |> Repo.all()
  end

  @doc """
  Gets a single recipe_ingredient.

  Raises `Ecto.NoResultsError` if the Recipe ingredient does not exist.

  ## Examples

      iex> get_recipe_ingredient!(123)
      %Recipe_ingredient{}

      iex> get_recipe_ingredient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe_ingredient!(recipe, id), do: Repo.get_by!(Recipe_ingredient, recipe_id: recipe.id, id: id)

  @doc """
  Creates a recipe_ingredient.

  ## Examples

      iex> create_recipe_ingredient(%{field: value})
      {:ok, %Recipe_ingredient{}}

      iex> create_recipe_ingredient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe_ingredient(recipe, attrs \\ %{}) do
    recipe
    |> Ecto.build_assoc(:recipe_ingredients)
    |> Recipe_ingredient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe_ingredient.

  ## Examples

      iex> update_recipe_ingredient(recipe_ingredient, %{field: new_value})
      {:ok, %Recipe_ingredient{}}

      iex> update_recipe_ingredient(recipe_ingredient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe_ingredient(%Recipe_ingredient{} = recipe_ingredient, attrs) do
    recipe_ingredient
    |> Recipe_ingredient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe_ingredient.

  ## Examples

      iex> delete_recipe_ingredient(recipe_ingredient)
      {:ok, %Recipe_ingredient{}}

      iex> delete_recipe_ingredient(recipe_ingredient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe_ingredient(%Recipe_ingredient{} = recipe_ingredient) do
    Repo.delete(recipe_ingredient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe_ingredient changes.

  ## Examples

      iex> change_recipe_ingredient(recipe_ingredient)
      %Ecto.Changeset{data: %Recipe_ingredient{}}

  """
  def change_recipe_ingredient(%Recipe_ingredient{} = recipe_ingredient, attrs \\ %{}) do
    Recipe_ingredient.changeset(recipe_ingredient, attrs)
  end
end
