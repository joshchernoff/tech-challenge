defmodule GhostGroupWeb.MedicalRecommendationLiveTest do
  use GhostGroupWeb.ConnCase

  import Phoenix.LiveViewTest
  import GhostGroup.MedicalRecommendationsFixtures

  @create_attrs %{
    expiration: %{day: 11, month: 5, year: 2022},
    issuer: "some issuer",
    number: "some number",
    state: "some state"
  }
  @update_attrs %{
    expiration: %{day: 12, month: 5, year: 2022},
    issuer: "some updated issuer",
    number: "some updated number",
    state: "some updated state"
  }
  @invalid_attrs %{
    expiration: %{day: 30, month: 2, year: 2022},
    issuer: nil,
    number: nil,
    state: nil
  }

  setup :register_and_log_in_user

  defp create_medical_recommendation(%{user: %{id: id}}) do
    medical_recommendation = medical_recommendation_fixture(%{user_id: id})
    %{medical_recommendation: medical_recommendation}
  end

  describe "Index" do
    setup [:create_medical_recommendation]

    test "lists all medical_recommendations", %{
      conn: conn,
      medical_recommendation: medical_recommendation
    } do
      {:ok, _index_live, html} =
        live(conn, Routes.medical_recommendation_index_path(conn, :index))

      assert html =~ "Listing Medical recommendations"
      assert html =~ medical_recommendation.image
    end

    test "saves new medical_recommendation", %{conn: conn} do
      {:ok, index_live, _html} =
        live(conn, Routes.medical_recommendation_index_path(conn, :index))

      assert index_live |> element("a", "New Medical recommendation") |> render_click() =~
               "New Medical recommendation"

      assert_patch(index_live, Routes.medical_recommendation_index_path(conn, :new))

      assert index_live
             |> form("#medical_recommendation-form", medical_recommendation: @invalid_attrs)
             |> render_change() =~ "is invalid"

      %{size: size} = File.stat!("priv/static/images/phoenix.png")

      image =
        file_input(index_live, "#medical_recommendation-form", :image, [
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
        |> form("#medical_recommendation-form", medical_recommendation: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.medical_recommendation_index_path(conn, :index))

      assert html =~ "Medical recommendation created successfully"
      assert html =~ "some image"
    end

    test "updates medical_recommendation in listing", %{
      conn: conn,
      medical_recommendation: medical_recommendation
    } do
      {:ok, index_live, _html} =
        live(conn, Routes.medical_recommendation_index_path(conn, :index))

      assert index_live
             |> element("#medical_recommendation-#{medical_recommendation.id} a", "Edit")
             |> render_click() =~
               "Edit Medical recommendation"

      assert_patch(
        index_live,
        Routes.medical_recommendation_index_path(conn, :edit, medical_recommendation)
      )

      assert index_live
             |> form("#medical_recommendation-form", medical_recommendation: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#medical_recommendation-form", medical_recommendation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.medical_recommendation_index_path(conn, :index))

      assert html =~ "Medical recommendation updated successfully"
    end

    test "deletes medical_recommendation in listing", %{
      conn: conn,
      medical_recommendation: medical_recommendation
    } do
      {:ok, index_live, _html} =
        live(conn, Routes.medical_recommendation_index_path(conn, :index))

      assert index_live
             |> element("#medical_recommendation-#{medical_recommendation.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#medical_recommendation-#{medical_recommendation.id}")
    end
  end

  describe "Show" do
    setup [:create_medical_recommendation]

    test "displays medical_recommendation", %{
      conn: conn,
      medical_recommendation: medical_recommendation
    } do
      {:ok, _show_live, html} =
        live(conn, Routes.medical_recommendation_show_path(conn, :show, medical_recommendation))

      assert html =~ "Show Medical recommendation"
      assert html =~ medical_recommendation.image
    end

    test "updates medical_recommendation within modal", %{
      conn: conn,
      medical_recommendation: medical_recommendation
    } do
      {:ok, show_live, _html} =
        live(conn, Routes.medical_recommendation_show_path(conn, :show, medical_recommendation))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Medical recommendation"

      assert_patch(
        show_live,
        Routes.medical_recommendation_show_path(conn, :edit, medical_recommendation)
      )

      assert show_live
             |> form("#medical_recommendation-form", medical_recommendation: @invalid_attrs)
             |> render_change() =~ "is invalid"

      %{size: size} = File.stat!("priv/static/images/phoenix.png")

      image =
        file_input(show_live, "#medical_recommendation-form", :image, [
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
        |> form("#medical_recommendation-form", medical_recommendation: @update_attrs)
        |> render_submit()
        |> follow_redirect(
          conn,
          Routes.medical_recommendation_show_path(conn, :show, medical_recommendation)
        )

      assert html =~ "Medical recommendation updated successfully"
    end
  end
end
