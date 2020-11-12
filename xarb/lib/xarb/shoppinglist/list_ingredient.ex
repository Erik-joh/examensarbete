defmodule Xarb.Shoppinglist.List_ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "list_ingredients" do
    field :amount, :float
    field :measurement, :string
    field :name, :string
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true
    field :done, :boolean , default: false
    belongs_to :list, Xarb.Shoppinglist.List

    timestamps()
  end

  @doc false
  def changeset(list_ingredient, attrs) do
    list_ingredient
    |> Map.put(:temp_id, (list_ingredient.temp_id || attrs["temp_id"]))
    |> cast(attrs, [:name, :amount, :measurement, :delete, :done])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :list_ingredients_name_list_id_index)
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
