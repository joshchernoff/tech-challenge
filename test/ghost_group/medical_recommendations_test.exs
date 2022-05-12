defmodule GhostGroup.MedicalRecommendationsTest do
  use GhostGroup.DataCase

  alias GhostGroup.MedicalRecommendations

  describe "medical_recommendations" do
    alias GhostGroup.MedicalRecommendations.MedicalRecommendation

    import GhostGroup.MedicalRecommendationsFixtures

    @invalid_attrs %{expiration: nil, image: nil, issuer: nil, number: nil, state: nil}

    test "list_medical_recommendations/0 returns all medical_recommendations" do
      medical_recommendation = medical_recommendation_fixture()
      assert MedicalRecommendations.list_medical_recommendations() == [medical_recommendation]
    end

    test "get_medical_recommendation!/1 returns the medical_recommendation with given id" do
      medical_recommendation = medical_recommendation_fixture()
      assert MedicalRecommendations.get_medical_recommendation!(medical_recommendation.id) == medical_recommendation
    end

    test "create_medical_recommendation/1 with valid data creates a medical_recommendation" do
      valid_attrs = %{expiration: ~D[2022-05-11], image: "some image", issuer: "some issuer", number: "some number", state: "some state"}

      assert {:ok, %MedicalRecommendation{} = medical_recommendation} = MedicalRecommendations.create_medical_recommendation(valid_attrs)
      assert medical_recommendation.expiration == ~D[2022-05-11]
      assert medical_recommendation.image == "some image"
      assert medical_recommendation.issuer == "some issuer"
      assert medical_recommendation.number == "some number"
      assert medical_recommendation.state == "some state"
    end

    test "create_medical_recommendation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MedicalRecommendations.create_medical_recommendation(@invalid_attrs)
    end

    test "update_medical_recommendation/2 with valid data updates the medical_recommendation" do
      medical_recommendation = medical_recommendation_fixture()
      update_attrs = %{expiration: ~D[2022-05-12], image: "some updated image", issuer: "some updated issuer", number: "some updated number", state: "some updated state"}

      assert {:ok, %MedicalRecommendation{} = medical_recommendation} = MedicalRecommendations.update_medical_recommendation(medical_recommendation, update_attrs)
      assert medical_recommendation.expiration == ~D[2022-05-12]
      assert medical_recommendation.image == "some updated image"
      assert medical_recommendation.issuer == "some updated issuer"
      assert medical_recommendation.number == "some updated number"
      assert medical_recommendation.state == "some updated state"
    end

    test "update_medical_recommendation/2 with invalid data returns error changeset" do
      medical_recommendation = medical_recommendation_fixture()
      assert {:error, %Ecto.Changeset{}} = MedicalRecommendations.update_medical_recommendation(medical_recommendation, @invalid_attrs)
      assert medical_recommendation == MedicalRecommendations.get_medical_recommendation!(medical_recommendation.id)
    end

    test "delete_medical_recommendation/1 deletes the medical_recommendation" do
      medical_recommendation = medical_recommendation_fixture()
      assert {:ok, %MedicalRecommendation{}} = MedicalRecommendations.delete_medical_recommendation(medical_recommendation)
      assert_raise Ecto.NoResultsError, fn -> MedicalRecommendations.get_medical_recommendation!(medical_recommendation.id) end
    end

    test "change_medical_recommendation/1 returns a medical_recommendation changeset" do
      medical_recommendation = medical_recommendation_fixture()
      assert %Ecto.Changeset{} = MedicalRecommendations.change_medical_recommendation(medical_recommendation)
    end
  end
end
