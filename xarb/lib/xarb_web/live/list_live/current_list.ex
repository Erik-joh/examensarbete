defmodule XarbWeb.ListLive.Current_list do
  use XarbWeb, :live_view
  alias Xarb.Accounts
  alias Xarb.Shoppinglist

  @impl true
  def mount(_params, %{"user_token" => token}, socket) do
    current_user = Accounts.get_user_by_session_token(token)
    IO.inspect("current list")
    {:ok, assign(socket, current_user: current_user, list: get_current_list(current_user))}
  end

  def get_current_list(user) do
    Shoppinglist.get_latest_list!(user)
  end

  @impl true
  def handle_event("done-list_ingredient", %{"id" => id}, socket) do
    Shoppinglist.toggle_list_ingredient_done(id)
    {:noreply, assign(socket, list: get_current_list(socket.assigns.current_user))}
  end
end
