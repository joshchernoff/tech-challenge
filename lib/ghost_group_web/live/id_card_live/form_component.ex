defmodule GhostGroupWeb.IdCardLive.FormComponent do
  use GhostGroupWeb, :live_component

  alias GhostGroup.IdCards

  @impl true
  def update(%{id_card: id_card} = assigns, socket) do
    changeset = IdCards.change_id_card(id_card)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"id_card" => id_card_params}, socket) do
    changeset =
      socket.assigns.id_card
      |> IdCards.change_id_card(id_card_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"id_card" => id_card_params}, socket) do
    save_id_card(socket, socket.assigns.action, id_card_params)
  end

  defp save_id_card(socket, :edit, id_card_params) do
    case IdCards.update_id_card(socket.assigns.id_card, id_card_params) do
      {:ok, _id_card} ->
        {:noreply,
         socket
         |> put_flash(:info, "Id card updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_id_card(socket, :new, id_card_params) do
    case IdCards.create_id_card(id_card_params) do
      {:ok, _id_card} ->
        {:noreply,
         socket
         |> put_flash(:info, "Id card created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
