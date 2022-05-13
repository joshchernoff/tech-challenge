defmodule GhostGroupWeb.IdCardLiveTest do
  use GhostGroupWeb.ConnCase

  import Phoenix.LiveViewTest
  import GhostGroup.IdCardsFixtures

  @create_attrs %{
    expiration: %{day: 11, month: 5, year: 2022},
    number: "some number",
    state: "some state"
  }
  @update_attrs %{
    expiration: %{day: 12, month: 5, year: 2022},
    number: "some updated number",
    state: "some updated state"
  }
  @invalid_attrs %{
    expiration: %{day: 30, month: 2, year: 2022},
    number: nil,
    state: nil
  }

  setup :register_and_log_in_user

  defp create_id_card(%{user: %{id: id}}) do
    id_card = id_card_fixture(%{user_id: id})
    %{id_card: id_card}
  end

  describe "Index" do
    setup [:create_id_card]

    test "lists all id_cards", %{
      conn: conn,
      id_card: id_card
    } do
      id_card2 =
        id_card_fixture(%{user_id: id_card.user_id, expiration: %{day: 18, month: 2, year: 2021}})

      {:ok, _index_live, html} = live(conn, Routes.id_card_index_path(conn, :index))
      assert html =~ "Listing Id cards"
      assert html =~ id_card.image
      assert html =~ "Expired! #{id_card2.expiration}"
    end

    test "saves new id_card", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.id_card_index_path(conn, :index))

      assert index_live |> element("a", "New Id card") |> render_click() =~
               "New Id card"

      assert_patch(index_live, Routes.id_card_index_path(conn, :new))

      assert index_live
             |> form("#id_card-form", id_card: @invalid_attrs)
             |> render_change() =~ "is invalid"

      %{size: size} = File.stat!("priv/static/images/phoenix.png")

      image =
        file_input(index_live, "#id_card-form", :image, [
          %{
            last_modified: 1_594_171_879_000,
            name: "phoenix.png",
            content: File.read!("priv/static/images/phoenix.png"),
            size: size,
            type: "image/png"
          }
        ])

      assert render_upload(image, "phoenix.png") =~ "100%"

      {:ok, _, html} =
        index_live
        |> form("#id_card-form", id_card: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.id_card_index_path(conn, :index))

      assert html =~ "Id card created successfully"
      assert html =~ "some image"
    end

    test "updates id_card in listing", %{
      conn: conn,
      id_card: id_card
    } do
      {:ok, index_live, _html} = live(conn, Routes.id_card_index_path(conn, :index))

      assert index_live
             |> element("#id_card-#{id_card.id} a", "Edit")
             |> render_click() =~
               "Edit Id card"

      assert_patch(
        index_live,
        Routes.id_card_index_path(conn, :edit, id_card)
      )

      assert index_live
             |> form("#id_card-form", id_card: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#id_card-form", id_card: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.id_card_index_path(conn, :index))

      assert html =~ "Id card updated successfully"
    end

    test "deletes id_card in listing", %{
      conn: conn,
      id_card: id_card
    } do
      {:ok, index_live, _html} = live(conn, Routes.id_card_index_path(conn, :index))

      assert index_live
             |> element("#id_card-#{id_card.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#id_card-#{id_card.id}")
    end
  end

  describe "Show" do
    setup [:create_id_card]

    test "displays epired", %{
      conn: conn,
      id_card: id_card
    } do
      id_card2 =
        id_card_fixture(%{user_id: id_card.user_id, expiration: %{day: 18, month: 2, year: 2021}})

      {:ok, _show_live, html} = live(conn, Routes.id_card_show_path(conn, :show, id_card2))
      assert html =~ "Expired!"

    end

    test "displays id_card", %{
      conn: conn,
      id_card: id_card
    } do
      {:ok, _show_live, html} = live(conn, Routes.id_card_show_path(conn, :show, id_card))

      assert html =~ "Show Id card"
      assert html =~ id_card.image
    end

    test "updates id_card within modal", %{
      conn: conn,
      id_card: id_card
    } do
      {:ok, show_live, _html} = live(conn, Routes.id_card_show_path(conn, :show, id_card))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Id card"

      assert_patch(
        show_live,
        Routes.id_card_show_path(conn, :edit, id_card)
      )

      assert show_live
             |> form("#id_card-form", id_card: @invalid_attrs)
             |> render_change() =~ "is invalid"

      %{size: size} = File.stat!("priv/static/images/phoenix.png")

      image =
        file_input(show_live, "#id_card-form", :image, [
          %{
            last_modified: 1_594_171_879_000,
            name: "phoenix.png",
            content: File.read!("priv/static/images/phoenix.png"),
            size: size,
            type: "image/png"
          }
        ])

      assert render_upload(image, "phoenix.png") =~ "100%"

      {:ok, _, html} =
        show_live
        |> form("#id_card-form", id_card: @update_attrs)
        |> render_submit()
        |> follow_redirect(
          conn,
          Routes.id_card_show_path(conn, :show, id_card)
        )

      assert html =~ "Id card updated successfully"
    end
  end
end
