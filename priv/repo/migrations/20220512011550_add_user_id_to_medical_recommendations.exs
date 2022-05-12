defmodule GhostGroup.Repo.Migrations.AddUserIdToMedicalRecommendations do
  use Ecto.Migration

  def change do
    alter table(:medical_recommendations) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
    end
  end
end
