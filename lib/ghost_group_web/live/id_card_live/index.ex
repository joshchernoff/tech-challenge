defmodule GhostGroupWeb.IdCardLive.Index do
  use GhostGroupWeb, :live_view

  alias GhostGroup.IdCards
  alias GhostGroup.IdCards.IdCard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :id_cards, list_id_cards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Id card")
    |> assign(:id_card, IdCards.get_id_card!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Id card")
    |> assign(:id_card, %IdCard{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Id cards")
    |> assign(:id_card, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    id_card = IdCards.get_id_card!(id)
    {:ok, _} = IdCards.delete_id_card(id_card)

    {:noreply, assign(socket, :id_cards, list_id_cards())}
  end

  defp list_id_cards do
    IdCards.list_id_cards()
  end
end
