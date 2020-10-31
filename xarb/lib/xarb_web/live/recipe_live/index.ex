defmodule XarbWeb.RecipeLive.Index do
  use XarbWeb, :live_view

  alias Xarb.Content
  alias Xarb.Content.Recipe
  alias Xarb.Accounts

  @impl true
  def mount(_params, %{"user_token" => token}, socket) do
    current_user = Accounts.get_user_by_session_token(token)
    {:ok, assign(socket, current_user: current_user ,recipes: list_recipes(current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Recipe")
    |> assign(:recipe, Content.get_recipe!(socket.assigns.current_user, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Recipe")
    |> assign(:recipe, %Recipe{recipe_ingredients: []})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Recipes")
    |> assign(:recipe, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    recipe = Content.get_recipe!(socket.assigns.current_user, id)
    {:ok, _} = Content.delete_recipe(recipe)

    {:noreply, assign(socket, :recipes, list_recipes(socket.assigns.current_user))}
  end


  defp list_recipes(user) do
    Content.list_recipes(user)
  end

end
