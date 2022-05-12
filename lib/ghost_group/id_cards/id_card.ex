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

    belongs_to :user, GhostGroup.Accounts.User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(id_card, attrs) do
    id_card
    |> cast(attrs, [:number, :state, :expiration, :image, :user_id])
    |> validate_required([:number, :state, :expiration, :image, :user_id])
  end
end
