defmodule GhostGroup.IdCardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GhostGroup.IdCards` context.
  """

  @doc """
  Generate a id_card.
  """
  def id_card_fixture(attrs \\ %{}) do
    {:ok, id_card} =
      attrs
      |> Enum.into(%{
        expiration: ~D[2022-05-11],
        image: "some image",
        number: "some number",
        state: "some state"
      })
      |> GhostGroup.IdCards.create_id_card()

    id_card
  end
end
