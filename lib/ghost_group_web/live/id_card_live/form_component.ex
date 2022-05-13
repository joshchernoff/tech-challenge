defmodule GhostGroupWeb.IdCardLive.FormComponent do
  use GhostGroupWeb, :live_component

  alias GhostGroup.IdCards

  @impl true
  def update(%{id_card: id_card} = assigns, socket) do
    changeset = IdCards.change_id_card(id_card)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
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
    case consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
           dest =
             Path.join([:code.priv_dir(:ghost_group), "static", "images", Path.basename(path)])

           File.cp!(path, dest)
           {:ok, Routes.static_path(socket, "/images/#{Path.basename(dest)}")}
         end) do
      [file_path] ->
        case IdCards.update_id_card(
               socket.assigns.id_card,
               id_card_params
               |> Map.put("image", file_path)
             ) do
          {:ok, _id_card} ->
            {:noreply,
             socket
             |> put_flash(:info, "Id card updated successfully")
             |> push_redirect(to: socket.assigns.return_to)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      _ ->
        case IdCards.update_id_card(
               socket.assigns.id_card,
               id_card_params
             ) do
          {:ok, _id_card} ->
            {:noreply,
             socket
             |> put_flash(:info, "Id card updated successfully")
             |> push_redirect(to: socket.assigns.return_to)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end
    end
  end

  defp save_id_card(
         %{assigns: %{current_user_id: current_user_id}} = socket,
         :new,
         id_card_params
       ) do
    [file_path] =
      consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:ghost_group), "static", "images", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, Routes.static_path(socket, "/images/#{Path.basename(dest)}")}
      end)

    case id_card_params
         |> Map.put("user_id", current_user_id)
         |> Map.put("image", file_path)
         |> IdCards.create_id_card() do
      {:ok, _id_card} ->
        {:noreply,
         socket
         |> put_flash(:info, "Id card created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
