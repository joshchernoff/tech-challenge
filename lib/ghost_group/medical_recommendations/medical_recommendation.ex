defmodule GhostGroup.MedicalRecommendations.MedicalRecommendation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "medical_recommendations" do
    field :expiration, :date
    field :image, :string
    field :issuer, :string
    field :number, :string
    field :state, :string

    belongs_to :user, GhostGroup.Accounts.User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(medical_recommendation, attrs) do
    medical_recommendation
    |> cast(attrs, [:number, :issuer, :state, :expiration, :image, :user_id])
    |> validate_required([:number, :issuer, :state, :expiration, :image, :user_id])
  end
end
