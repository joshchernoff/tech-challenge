defmodule GhostGroup.Repo.Migrations.CreateIdCards do
  use Ecto.Migration

  def change do
    create table(:id_cards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :number, :string
      add :state, :string
      add :expiration, :date
      add :image, :string

      timestamps()
    end
  end
end
