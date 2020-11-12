defmodule Xarb.Shoppinglist.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :finished, :boolean, default: false
    field :titel, :string
    field :parser, :string, virtual: true
    belongs_to :user, Xarb.Accounts.User
    has_many :list_ingredients, Xarb.Shoppinglist.List_ingredient

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:titel, :finished])
    |> validate_required([:titel, :finished])
    |> cast_assoc(:list_ingredients)
  end
end
