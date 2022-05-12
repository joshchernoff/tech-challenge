defmodule GhostGroupWeb.MedicalRecommendationLive.Index do
  use GhostGroupWeb, :live_view

  alias GhostGroup.MedicalRecommendations
  alias GhostGroup.MedicalRecommendations.MedicalRecommendation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :medical_recommendations, list_medical_recommendations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Medical recommendation")
    |> assign(:medical_recommendation, MedicalRecommendations.get_medical_recommendation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Medical recommendation")
    |> assign(:medical_recommendation, %MedicalRecommendation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Medical recommendations")
    |> assign(:medical_recommendation, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    medical_recommendation = MedicalRecommendations.get_medical_recommendation!(id)
    {:ok, _} = MedicalRecommendations.delete_medical_recommendation(medical_recommendation)

    {:noreply, assign(socket, :medical_recommendations, list_medical_recommendations())}
  end

  defp list_medical_recommendations do
    MedicalRecommendations.list_medical_recommendations()
  end
end
