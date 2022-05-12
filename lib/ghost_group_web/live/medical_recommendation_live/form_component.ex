defmodule GhostGroupWeb.MedicalRecommendationLive.FormComponent do
  use GhostGroupWeb, :live_component

  alias GhostGroup.MedicalRecommendations

  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    {:ok, assign(socket, current_user: current_user)}
  end

  @impl true
  def update(%{medical_recommendation: medical_recommendation} = assigns, socket) do
    changeset = MedicalRecommendations.change_medical_recommendation(medical_recommendation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
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

  defp save_medical_recommendation(
         %{assigns: %{current_user_id: current_user_id}} = socket,
         :new,
         medical_recommendation_params
       ) do

    case medical_recommendation_params
         |> Map.merge(%{"user_id" => current_user_id})
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
end
