defmodule GhostGroup.MedicalRecommendations do
  @moduledoc """
  The MedicalRecommendations context.
  """

  import Ecto.Query, warn: false
  alias GhostGroup.Repo

  alias GhostGroup.MedicalRecommendations.MedicalRecommendation

  @doc """
  Returns the list of medical_recommendations.

  ## Examples

      iex> list_medical_recommendations()
      [%MedicalRecommendation{}, ...]

  """
  def list_medical_recommendations(current_user_id: current_user_id) do
    from(mr in MedicalRecommendation, where: mr.user_id == ^current_user_id) |> Repo.all()
  end

  @doc """
  Gets a single medical_recommendation.

  Raises `Ecto.NoResultsError` if the Medical recommendation does not exist.

  ## Examples

      iex> get_medical_recommendation!(123)
      %MedicalRecommendation{}

      iex> get_medical_recommendation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_medical_recommendation!(id, current_user_id) do
    from(mr in MedicalRecommendation, where: mr.user_id == ^current_user_id and mr.id == ^id)
    |> Repo.one!()
  end

  @doc """
  Creates a medical_recommendation.

  ## Examples

      iex> create_medical_recommendation(%{field: value})
      {:ok, %MedicalRecommendation{}}

      iex> create_medical_recommendation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_medical_recommendation(attrs \\ %{}) do
    %MedicalRecommendation{}
    |> MedicalRecommendation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a medical_recommendation.

  ## Examples

      iex> update_medical_recommendation(medical_recommendation, %{field: new_value})
      {:ok, %MedicalRecommendation{}}

      iex> update_medical_recommendation(medical_recommendation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_medical_recommendation(%MedicalRecommendation{} = medical_recommendation, attrs) do
    medical_recommendation
    |> MedicalRecommendation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a medical_recommendation.

  ## Examples

      iex> delete_medical_recommendation(medical_recommendation)
      {:ok, %MedicalRecommendation{}}

      iex> delete_medical_recommendation(medical_recommendation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_medical_recommendation(%MedicalRecommendation{} = medical_recommendation) do
    Repo.delete(medical_recommendation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking medical_recommendation changes.

  ## Examples

      iex> change_medical_recommendation(medical_recommendation)
      %Ecto.Changeset{data: %MedicalRecommendation{}}

  """
  def change_medical_recommendation(
        %MedicalRecommendation{} = medical_recommendation,
        attrs \\ %{}
      ) do
    MedicalRecommendation.changeset(medical_recommendation, attrs)
  end
end
