defmodule GhostGroupWeb.IdCardLive.Show do
  use GhostGroupWeb, :live_view

  alias GhostGroup.IdCards

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: %{id: current_user_id}}} = socket) do
    {:ok, assign(socket, :current_user_id, current_user_id)}
  end

  @impl true
  def handle_params(
        %{"id" => id},
        _,
        %{assigns: %{current_user: %{id: current_user_id}}} = socket
      ) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(
       :id_card,
       IdCards.get_id_card!(id, current_user_id)
     )
     |> assign(:current_user_id, %{id: current_user_id})}
  end

  defp page_title(:show), do: "Show Id card"
  defp page_title(:edit), do: "Edit Id card"
end
