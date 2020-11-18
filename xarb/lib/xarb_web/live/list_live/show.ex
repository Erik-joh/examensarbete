defmodule XarbWeb.ListLive.Show do
  use XarbWeb, :live_view

  alias Xarb.Shoppinglist
  alias Xarb.Shoppinglist.List
  alias Xarb.Accounts

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
     |> assign(:list, get_list(socket.assigns.current_user ,id))}
  end

  defp page_title(:show), do: "Visa inköpslista"
  defp page_title(:edit), do: "Ändra inköpslista"

  def get_list(user,id) do
    list = Shoppinglist.get_list!(user,id)
    if list.list_ingredients == nil do
      %List{list_ingredients: []}
    else
      list
    end
  end
end
