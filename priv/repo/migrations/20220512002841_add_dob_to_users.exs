defmodule GhostGroup.Repo.Migrations.AddDobToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :dob, :date, null: false
    end
  end
end
