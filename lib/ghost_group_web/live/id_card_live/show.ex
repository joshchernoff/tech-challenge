defmodule GhostGroupWeb.IdCardLive.Show do
  use GhostGroupWeb, :live_view

  alias GhostGroup.IdCards

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:id_card, IdCards.get_id_card!(id))}
  end

  defp page_title(:show), do: "Show Id card"
  defp page_title(:edit), do: "Edit Id card"
end
