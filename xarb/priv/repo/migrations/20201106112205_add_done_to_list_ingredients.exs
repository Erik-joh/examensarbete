defmodule Xarb.Repo.Migrations.AddDoneToListIngredients do
  use Ecto.Migration

  def change do
    alter table(:list_ingredients) do
      add :done, :boolean , default: false
    end
  end
end
