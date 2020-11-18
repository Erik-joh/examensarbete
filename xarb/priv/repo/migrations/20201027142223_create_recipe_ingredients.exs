defmodule Xarb.Repo.Migrations.CreateRecipeIngredients do
  use Ecto.Migration

  def change do
    create table(:recipe_ingredients) do
      add :name, :string, null: false
      add :amount, :float
      add :measurement, :string
      add :recipe_id, references(:recipes, on_delete: :delete_all)

      timestamps()
    end

    create index(:recipe_ingredients, [:recipe_id])
    create unique_index(:recipe_ingredients, [:name, :recipe_id])
  end
end
