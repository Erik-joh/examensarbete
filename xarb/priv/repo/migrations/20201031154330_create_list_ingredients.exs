defmodule Xarb.Repo.Migrations.CreateListIngredients do
  use Ecto.Migration

  def change do
    create table(:list_ingredients) do
      add :name, :string, null: false
      add :amount, :float
      add :measurement, :string
      add :list_id, references(:lists, on_delete: :delete_all)

      timestamps()
    end

    create index(:list_ingredients, [:list_id])
    create unique_index(:list_ingredients, [:name, :list_id])
  end
end
