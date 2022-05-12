defmodule GhostGroup.Repo.Migrations.AddUserIdToIdCards do
  use Ecto.Migration

  def change do
    alter table(:id_cards) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
    end
  end
end
