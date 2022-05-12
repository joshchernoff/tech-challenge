defmodule GhostGroup.MedicalRecommendationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GhostGroup.MedicalRecommendations` context.
  """

  @doc """
  Generate a medical_recommendation.
  """
  def medical_recommendation_fixture(attrs \\ %{}) do
    {:ok, medical_recommendation} =
      attrs
      |> Enum.into(%{
        expiration: ~D[2022-05-11],
        image: "some image",
        issuer: "some issuer",
        number: "some number",
        state: "some state"
      })
      |> GhostGroup.MedicalRecommendations.create_medical_recommendation()

    medical_recommendation
  end
end
