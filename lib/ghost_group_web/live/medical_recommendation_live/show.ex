defmodule GhostGroupWeb.MedicalRecommendationLive.Show do
  use GhostGroupWeb, :live_view

  alias GhostGroup.MedicalRecommendations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:medical_recommendation, MedicalRecommendations.get_medical_recommendation!(id))}
  end

  defp page_title(:show), do: "Show Medical recommendation"
  defp page_title(:edit), do: "Edit Medical recommendation"
end
