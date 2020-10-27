defmodule Xarb.Content.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :instructions, :string
    field :source, :string
    field :title, :string
    belongs_to :user, Xarb.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :instructions, :source])
    |> validate_required([:title, :instructions, :source])
    |> unique_constraint(:title, name: :recipes_title_index)
  end
end
