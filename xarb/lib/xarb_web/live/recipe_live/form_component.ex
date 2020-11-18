defmodule XarbWeb.RecipeLive.FormComponent do
  use XarbWeb, :live_component

  alias Xarb.Content
  alias Xarb.Content.Recipe_ingredient
  alias Xarb.Parser

  @impl true
  def update(%{recipe: recipe} = assigns, socket) do
    changeset = Content.change_recipe(recipe)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset =
      socket.assigns.recipe
      |> Content.change_recipe(recipe_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do

    save_recipe(socket, socket.assigns.action, recipe_params)
  end
  def handle_event("add-recipe_ingredient", _, socket) do
    existing_recipe_ingredients = Map.get(socket.assigns.changeset.changes, :recipe_ingredients, socket.assigns.recipe.recipe_ingredients)

    recipe_ingredients =
      existing_recipe_ingredients
      |> Enum.concat([
        Content.change_recipe_ingredient(%Recipe_ingredient{temp_id: get_temp_id()}) # NOTE temp_id
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:recipe_ingredients, recipe_ingredients)

    {:noreply, assign(socket, changeset: changeset)}
  end
  def handle_event("remove-recipe_ingredient", %{"remove" => remove_id}, socket) do
    recipe_ingredients =
      socket.assigns.changeset.changes.recipe_ingredients
      |> Enum.reject(fn %{data: recipe_ingredient} ->
        recipe_ingredient.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:recipe_ingredients, recipe_ingredients)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-parsed_recipe_ingredients", %{"recipe" => recipe_params}, socket) do
    changeset = case IO.inspect(Parser.parse_ingredients(recipe_params)) do
      {:ok, list} -> add_parsed_ingredients_to_changeset(list,socket)
      {:error, _} -> Map.put(socket.assigns.changeset, :errors, [parser: {"couldnt parse ingredients",[vailidation: :required]}])
    end
    {:noreply, assign(socket, :changeset, changeset)}
  end
  def add_parsed_ingredients_to_changeset(list, socket) do
    existing_recipe_ingredients = Map.get(socket.assigns.changeset.changes, :recipe_ingredients, socket.assigns.recipe.recipe_ingredients)
    recipe_ingredients =
      existing_recipe_ingredients
        |> Enum.concat(
            add_parsed_ingredients_to_changeset_helper(list)
          )
    socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:recipe_ingredients, recipe_ingredients)
  end

  defp add_parsed_ingredients_to_changeset_helper([head]) do
      [Content.change_recipe_ingredient(%Recipe_ingredient{temp_id: get_temp_id()}, head)]
  end
  defp add_parsed_ingredients_to_changeset_helper([head|tail]) do
    [
      Content.change_recipe_ingredient(%Recipe_ingredient{temp_id: get_temp_id()}, head) | add_parsed_ingredients_to_changeset_helper(tail)
    ]
  end

  defp save_recipe(socket, :edit, recipe_params) do
    case Content.update_recipe(socket.assigns.recipe, recipe_params) do
      {:ok, _recipe} ->
        {:noreply,
         socket
         |> put_flash(:info, "Recipe updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_recipe(socket, :new, recipe_params) do
    case Content.create_recipe(socket.assigns.current_user, recipe_params) do
      {:ok, _recipe} ->
        {:noreply,
         socket
         |> put_flash(:info, "Recipe created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


  # Generates a random string
  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64 |> binary_part(0, 5)
end
