defmodule GhostGroup.IdCardsTest do
  use GhostGroup.DataCase

  alias GhostGroup.IdCards

  describe "id_cards" do
    alias GhostGroup.IdCards.IdCard

    import GhostGroup.IdCardsFixtures

    @invalid_attrs %{expiration: nil, image: nil, number: nil, state: nil}

    test "list_id_cards/0 returns all id_cards" do
      id_card = id_card_fixture()
      assert IdCards.list_id_cards() == [id_card]
    end

    test "get_id_card!/1 returns the id_card with given id" do
      id_card = id_card_fixture()
      assert IdCards.get_id_card!(id_card.id) == id_card
    end

    test "create_id_card/1 with valid data creates a id_card" do
      valid_attrs = %{
        expiration: ~D[2022-05-11],
        image: "some image",
        number: "some number",
        state: "some state"
      }

      assert {:ok, %IdCard{} = id_card} = IdCards.create_id_card(valid_attrs)
      assert id_card.expiration == ~D[2022-05-11]
      assert id_card.image == "some image"
      assert id_card.number == "some number"
      assert id_card.state == "some state"
    end

    test "create_id_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = IdCards.create_id_card(@invalid_attrs)
    end

    test "update_id_card/2 with valid data updates the id_card" do
      id_card = id_card_fixture()

      update_attrs = %{
        expiration: ~D[2022-05-12],
        image: "some updated image",
        number: "some updated number",
        state: "some updated state"
      }

      assert {:ok, %IdCard{} = id_card} = IdCards.update_id_card(id_card, update_attrs)
      assert id_card.expiration == ~D[2022-05-12]
      assert id_card.image == "some updated image"
      assert id_card.number == "some updated number"
      assert id_card.state == "some updated state"
    end

    test "update_id_card/2 with invalid data returns error changeset" do
      id_card = id_card_fixture()
      assert {:error, %Ecto.Changeset{}} = IdCards.update_id_card(id_card, @invalid_attrs)
      assert id_card == IdCards.get_id_card!(id_card.id)
    end

    test "delete_id_card/1 deletes the id_card" do
      id_card = id_card_fixture()
      assert {:ok, %IdCard{}} = IdCards.delete_id_card(id_card)
      assert_raise Ecto.NoResultsError, fn -> IdCards.get_id_card!(id_card.id) end
    end

    test "change_id_card/1 returns a id_card changeset" do
      id_card = id_card_fixture()
      assert %Ecto.Changeset{} = IdCards.change_id_card(id_card)
    end
  end
end
