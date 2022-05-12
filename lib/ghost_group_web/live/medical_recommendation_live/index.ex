defmodule GhostGroupWeb.MedicalRecommendationLive.Index do
  use GhostGroupWeb, :live_view

  alias GhostGroup.MedicalRecommendations
  alias GhostGroup.MedicalRecommendations.MedicalRecommendation

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: %{id: current_user_id}}} = socket) do
    {:ok,
     assign(
       socket,
       :medical_recommendations,
       list_medical_recommendations(current_user_id: current_user_id)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(%{assigns: %{current_user: %{id: current_user_id}}} = socket, :edit, %{
         "id" => id
       }) do
    socket
    |> assign(:page_title, "Edit Medical recommendation")
    |> assign(
      :medical_recommendation,
      MedicalRecommendations.get_medical_recommendation!(id, current_user_id)
    )
    |> assign(:current_user_id, current_user_id)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Medical recommendation")
    |> assign(:medical_recommendation, %MedicalRecommendation{})
    |> assign(:current_user_id, socket.assigns.current_user.id)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Medical recommendations")
    |> assign(:medical_recommendation, nil)
  end

  @impl true
  def handle_event(
        "delete",
        %{"id" => id},
        %{assigns: %{current_user_id: current_user_id}} = socket
      ) do
    medical_recommendation =
      MedicalRecommendations.get_medical_recommendation!(id, current_user_id)

    {:ok, _} = MedicalRecommendations.delete_medical_recommendation(medical_recommendation)

    {:noreply,
     assign(
       socket,
       :medical_recommendations,
       list_medical_recommendations(current_user_id: current_user_id)
     )}
  end

  def handle_event(
        "delete",
        %{"id" => id},
        %{assigns: %{current_user: %{id: current_user_id}}} = socket
      ) do
    medical_recommendation =
      MedicalRecommendations.get_medical_recommendation!(id, current_user_id)

    {:ok, _} = MedicalRecommendations.delete_medical_recommendation(medical_recommendation)

    {:noreply,
     assign(
       socket,
       :medical_recommendations,
       list_medical_recommendations(current_user_id: current_user_id)
     )}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  defp list_medical_recommendations(current_user_id: current_user_id) do
    MedicalRecommendations.list_medical_recommendations(current_user_id: current_user_id)
  end
end
