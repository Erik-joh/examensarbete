defmodule XarbWeb.RecipeLive.Show do
  use XarbWeb, :live_view

  alias Xarb.Content
  alias Xarb.Accounts
  alias Xarb.Content.Recipe

  @impl true
  def mount(_params, %{"user_token" => token}, socket) do
    current_user = Accounts.get_user_by_session_token(token)
    {:ok, assign(socket, current_user: current_user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:recipe, get_recipe(socket.assigns.current_user ,id))}
  end

  defp page_title(:show), do: "Show Recipe"
  defp page_title(:edit), do: "Edit Recipe"

  def get_recipe(user,id) do
    recipe = Content.get_recipe!(user,id)
    if recipe.recipe_ingredients == nil do
      %Recipe{recipe_ingredients: []}
    else
      recipe
    end
  end
end
