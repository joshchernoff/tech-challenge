defmodule GhostGroupWeb.MedicalRecommendationLive.FormComponent do
  use GhostGroupWeb, :live_component

  alias GhostGroup.MedicalRecommendations

  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    {:ok,
     socket
     |> assign(current_user: current_user)
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  @impl true
  def update(%{medical_recommendation: medical_recommendation} = assigns, socket) do
    changeset = MedicalRecommendations.change_medical_recommendation(medical_recommendation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  @impl true
  def handle_event(
        "validate",
        %{"medical_recommendation" => medical_recommendation_params},
        socket
      ) do
    changeset =
      socket.assigns.medical_recommendation
      |> MedicalRecommendations.change_medical_recommendation(medical_recommendation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"medical_recommendation" => medical_recommendation_params}, socket) do
    save_medical_recommendation(socket, socket.assigns.action, medical_recommendation_params)
  end

  defp save_medical_recommendation(socket, :edit, medical_recommendation_params) do
    case consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
           dest =
             Path.join([:code.priv_dir(:ghost_group), "static", "images", Path.basename(path)])

           File.cp!(path, dest)
           {:ok, Routes.static_path(socket, "/images/#{Path.basename(dest)}")}
         end) do
      [file_path] ->
        case MedicalRecommendations.update_medical_recommendation(
               socket.assigns.medical_recommendation,
               medical_recommendation_params
               |> Map.put("image", file_path)
             ) do
          {:ok, _medical_recommendation} ->
            {:noreply,
             socket
             |> put_flash(:info, "Medical recommendation updated successfully")
             |> push_redirect(to: socket.assigns.return_to)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      _ ->
        case MedicalRecommendations.update_medical_recommendation(
               socket.assigns.medical_recommendation,
               medical_recommendation_params
             ) do
          {:ok, _medical_recommendation} ->
            {:noreply,
             socket
             |> put_flash(:info, "Medical recommendation updated successfully")
             |> push_redirect(to: socket.assigns.return_to)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end
    end
  end

  defp save_medical_recommendation(
         %{assigns: %{current_user_id: current_user_id}} = socket,
         :new,
         medical_recommendation_params
       ) do
    [file_path] =
      consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:ghost_group), "static", "images", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, Routes.static_path(socket, "/images/#{Path.basename(dest)}")}
      end)

    case medical_recommendation_params
         |> Map.put("user_id", current_user_id)
         |> Map.put("image", file_path)
         |> MedicalRecommendations.create_medical_recommendation() do
      {:ok, _medical_recommendation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Medical recommendation created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
