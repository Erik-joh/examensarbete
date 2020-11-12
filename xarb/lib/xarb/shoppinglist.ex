defmodule Xarb.Shoppinglist do
  @moduledoc """
  The Shoppinglist context.
  """

  import Ecto.Query, warn: false
  alias Xarb.Repo

  alias Xarb.Shoppinglist.{List, List_ingredient}

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists(user) do
    from(l in List, where: [user_id: ^user.id], order_by: [desc: :inserted_at])
    |> Repo.all()
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(user, id) do
    Repo.get_by!(List, user_id: user.id, id: id)
    |> Repo.preload(list_ingredients: from(li in List_ingredient, order_by: li.id))
  end

  def get_latest_list!(user) do
    case from(l in List, where: [user_id: ^user.id], order_by: [desc: :updated_at])
     |> Repo.all()
     |> Repo.preload(list_ingredients: from(li in List_ingredient, order_by: [desc: :updated_at])) do
      [] -> []
      [head|_] -> head
    end
  end


  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:lists)
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end

  alias Xarb.Shoppinglist.List_ingredient

  @doc """
  Returns the list of list_ingredients.

  ## Examples

      iex> list_list_ingredients()
      [%List_ingredient{}, ...]

  """
  def list_list_ingredients(list) do
    from(li in List_ingredient, where: [list_id: ^list.id], order_by: [asc: :id])
    |> Repo.all()
  end

  @doc """
  Gets a single list_ingredient.

  Raises `Ecto.NoResultsError` if the List ingredient does not exist.

  ## Examples

      iex> get_list_ingredient!(123)
      %List_ingredient{}

      iex> get_list_ingredient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list_ingredient!(list, id), do: Repo.get_by!(List_ingredient, list_id: list.id, id: id)

  @doc """
  Creates a list_ingredient.

  ## Examples

      iex> create_list_ingredient(%{field: value})
      {:ok, %List_ingredient{}}

      iex> create_list_ingredient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list_ingredient(list, attrs \\ %{}) do
    list
    |> Ecto.build_assoc(:list_ingredients)
    |> List_ingredient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list_ingredient.

  ## Examples

      iex> update_list_ingredient(list_ingredient, %{field: new_value})
      {:ok, %List_ingredient{}}

      iex> update_list_ingredient(list_ingredient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list_ingredient(%List_ingredient{} = list_ingredient, attrs) do
    list_ingredient
    |> List_ingredient.changeset(attrs)
    |> Repo.update()
  end

  def toggle_list_ingredient_done(id) do
    ingredient = Repo.get!(List_ingredient, id)
    Ecto.Changeset.change(ingredient, done: !ingredient.done)
      |> Repo.update()
  end
  @doc """
  Deletes a list_ingredient.

  ## Examples

      iex> delete_list_ingredient(list_ingredient)
      {:ok, %List_ingredient{}}

      iex> delete_list_ingredient(list_ingredient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list_ingredient(%List_ingredient{} = list_ingredient) do
    Repo.delete(list_ingredient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list_ingredient changes.

  ## Examples

      iex> change_list_ingredient(list_ingredient)
      %Ecto.Changeset{data: %List_ingredient{}}

  """
  def change_list_ingredient(%List_ingredient{} = list_ingredient, attrs \\ %{}) do
    List_ingredient.changeset(list_ingredient, attrs)
  end
end
