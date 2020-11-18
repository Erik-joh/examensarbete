defmodule XarbWeb.ListLive.FormComponent do
  use XarbWeb, :live_component

  alias Xarb.Shoppinglist
  alias Xarb.Shoppinglist.List_ingredient
  alias Xarb.Parser

  @impl true
  def update(%{list: list} = assigns, socket) do
    changeset = Shoppinglist.change_list(list)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end


  @impl true
  def handle_event("validate", %{"list" => list_params}, socket) do
    changeset = socket.assigns.list
        |> Shoppinglist.change_list(list_params)
        |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end



  def handle_event("save", %{"list" => list_params}, socket) do
    save_list(socket, socket.assigns.action, list_params)
  end

  def handle_event("add-list_ingredient", _, socket) do
    existing_list_ingredients = Map.get(socket.assigns.changeset.changes, :list_ingredients, socket.assigns.list.list_ingredients)

    list_ingredients =
      existing_list_ingredients
      |> Enum.concat([
        Shoppinglist.change_list_ingredient(%List_ingredient{temp_id: get_temp_id()})
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:list_ingredients, list_ingredients)

    {:noreply, assign(socket, changeset: changeset)}
  end
  def handle_event("remove-list_ingredient", %{"remove" => remove_id}, socket) do
    list_ingredients =
      socket.assigns.changeset.changes.list_ingredients
      |> Enum.reject(fn %{data: list_ingredient} ->
        list_ingredient.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:list_ingredients, list_ingredients)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-parsed_list_ingredients", %{"list" => list_params}, socket) do
    changeset = case IO.inspect(Parser.parse_ingredients(list_params)) do
      {:ok, list} -> add_parsed_ingredients_to_changeset(list,socket)
      {:error, _} -> Map.put(socket.assigns.changeset, :errors, [parser: {"couldnt parse ingredients",[vailidation: :required]}])
    end
    {:noreply, assign(socket, :changeset, changeset)}
  end
  def add_parsed_ingredients_to_changeset(list, socket) do
    existing_list_ingredients = Map.get(socket.assigns.changeset.changes, :list_ingredients, socket.assigns.list.list_ingredients)
    list_ingredients =
      existing_list_ingredients
        |> Enum.concat(
            add_parsed_ingredients_to_changeset_helper(list)
          )
    socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:list_ingredients, list_ingredients)
  end

  defp add_parsed_ingredients_to_changeset_helper([head]) do
      [Shoppinglist.change_list_ingredient(%List_ingredient{temp_id: get_temp_id()}, head)]
  end
  defp add_parsed_ingredients_to_changeset_helper([head|tail]) do
    [
      Shoppinglist.change_list_ingredient(%List_ingredient{temp_id: get_temp_id()}, head) | add_parsed_ingredients_to_changeset_helper(tail)
    ]
  end

  defp save_list(socket, :edit, list_params) do
    case Shoppinglist.update_list(socket.assigns.list, list_params) do
      {:ok, _list} ->
        {:noreply,
         socket
         |> put_flash(:info, "List updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_list(socket, :new, list_params) do
    case Shoppinglist.create_list(socket.assigns.current_user , list_params) do
      {:ok, _list} ->
        {:noreply,
         socket
         |> put_flash(:info, "List created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64 |> binary_part(0, 5)

end
