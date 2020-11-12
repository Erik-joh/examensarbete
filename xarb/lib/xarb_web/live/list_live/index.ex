defmodule XarbWeb.ListLive.Index do
  use XarbWeb, :live_view

  alias Xarb.Shoppinglist
  alias Xarb.Shoppinglist.List
  alias Xarb.Accounts

  @impl true
  def mount(_params, %{"user_token" => token}, socket) do
    current_user = Accounts.get_user_by_session_token(token)
    {:ok, assign(socket, current_user: current_user, lists: list_lists(current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Shoppinglist.get_list!(socket.assigns.current_user, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %List{list_ingredients: []})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lists")
    |> assign(:list, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = Shoppinglist.get_list!(socket.assigns.current_user, id)
    {:ok, _} = Shoppinglist.delete_list(list)

    {:noreply, assign(socket, :lists, list_lists(socket.assigns.current_user))}
  end

  defp list_lists(user) do
    Shoppinglist.list_lists(user)
  end
end
