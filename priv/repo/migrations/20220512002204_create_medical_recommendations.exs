defmodule GhostGroup.Repo.Migrations.CreateMedicalRecommendations do
  use Ecto.Migration

  def change do
    create table(:medical_recommendations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :number, :string
      add :issuer, :string
      add :state, :string
      add :expiration, :date
      add :image, :string

      timestamps()
    end
  end
end
