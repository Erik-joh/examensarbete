defmodule Xarb.Content.Recipe_ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipe_ingredients" do
    field :amount, :float
    field :measurement, :string
    field :name, :string
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true
    belongs_to :recipe, Xarb.Content.Recipe

    timestamps()
  end

  @doc false
  def changeset(recipe_ingredient, attrs) do
    recipe_ingredient
    |> Map.put(:temp_id, (recipe_ingredient.temp_id || attrs["temp_id"]))
    |> cast(attrs, [:name, :amount, :measurement, :delete])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :recipe_ingredients_name_recipe_id_index)
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset
  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
