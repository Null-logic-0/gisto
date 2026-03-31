defmodule GistoWeb.GistLiveTest do
  use GistoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Gisto.GistsFixtures

  @create_attrs %{description: "some description", file_name: "some file_name", markup_text: "some markup_text"}
  @update_attrs %{description: "some updated description", file_name: "some updated file_name", markup_text: "some updated markup_text"}
  @invalid_attrs %{description: nil, file_name: nil, markup_text: nil}

  setup :register_and_log_in_user

  defp create_gist(%{scope: scope}) do
    gist = gist_fixture(scope)

    %{gist: gist}
  end

  describe "Index" do
    setup [:create_gist]

    test "lists all gists", %{conn: conn, gist: gist} do
      {:ok, _index_live, html} = live(conn, ~p"/gists")

      assert html =~ "Listing Gists"
      assert html =~ gist.file_name
    end

    test "saves new gist", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/gists")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Gist")
               |> render_click()
               |> follow_redirect(conn, ~p"/gists/new")

      assert render(form_live) =~ "New Gist"

      assert form_live
             |> form("#gist-form", gist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#gist-form", gist: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/gists")

      html = render(index_live)
      assert html =~ "Gist created successfully"
      assert html =~ "some file_name"
    end

    test "updates gist in listing", %{conn: conn, gist: gist} do
      {:ok, index_live, _html} = live(conn, ~p"/gists")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#gists-#{gist.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/gists/#{gist}/edit")

      assert render(form_live) =~ "Edit Gist"

      assert form_live
             |> form("#gist-form", gist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#gist-form", gist: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/gists")

      html = render(index_live)
      assert html =~ "Gist updated successfully"
      assert html =~ "some updated file_name"
    end

    test "deletes gist in listing", %{conn: conn, gist: gist} do
      {:ok, index_live, _html} = live(conn, ~p"/gists")

      assert index_live |> element("#gists-#{gist.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#gists-#{gist.id}")
    end
  end

  describe "Show" do
    setup [:create_gist]

    test "displays gist", %{conn: conn, gist: gist} do
      {:ok, _show_live, html} = live(conn, ~p"/gists/#{gist}")

      assert html =~ "Show Gist"
      assert html =~ gist.file_name
    end

    test "updates gist and returns to show", %{conn: conn, gist: gist} do
      {:ok, show_live, _html} = live(conn, ~p"/gists/#{gist}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/gists/#{gist}/edit?return_to=show")

      assert render(form_live) =~ "Edit Gist"

      assert form_live
             |> form("#gist-form", gist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#gist-form", gist: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/gists/#{gist}")

      html = render(show_live)
      assert html =~ "Gist updated successfully"
      assert html =~ "some updated file_name"
    end
  end
end
