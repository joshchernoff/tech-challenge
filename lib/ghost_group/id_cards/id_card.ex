defmodule GhostGroup.IdCards.IdCard do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "id_cards" do
    field :expiration, :date
    field :image, :string
    field :number, :string
    field :state, :string

    timestamps()
  end

  @doc false
  def changeset(id_card, attrs) do
    id_card
    |> cast(attrs, [:number, :state, :expiration, :image])
    |> validate_required([:number, :state, :expiration, :image])
  end
end
