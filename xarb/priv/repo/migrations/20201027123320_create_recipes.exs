defmodule Xarb.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :title, :string, null: false
      add :instructions, :text, null: false
      add :source, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:recipes, [:user_id])
    create unique_index(:recipes, [:title])
  end
end
