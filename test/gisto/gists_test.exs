defmodule Gisto.GistsTest do
  use Gisto.DataCase

  alias Gisto.Gists

  describe "gists" do
    alias Gisto.Gists.Gist

    import Gisto.AccountsFixtures, only: [user_scope_fixture: 0]
    import Gisto.GistsFixtures

    @invalid_attrs %{description: nil, file_name: nil, markup_text: nil}

    test "list_gists/1 returns all scoped gists" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      gist = gist_fixture(scope)
      other_gist = gist_fixture(other_scope)
      assert Gists.list_gists(scope) == [gist]
      assert Gists.list_gists(other_scope) == [other_gist]
    end

    test "get_gist!/2 returns the gist with given id" do
      scope = user_scope_fixture()
      gist = gist_fixture(scope)
      other_scope = user_scope_fixture()
      assert Gists.get_gist!(scope, gist.id) == gist
      assert_raise Ecto.NoResultsError, fn -> Gists.get_gist!(other_scope, gist.id) end
    end

    test "create_gist/2 with valid data creates a gist" do
      valid_attrs = %{description: "some description", file_name: "some file_name", markup_text: "some markup_text"}
      scope = user_scope_fixture()

      assert {:ok, %Gist{} = gist} = Gists.create_gist(scope, valid_attrs)
      assert gist.description == "some description"
      assert gist.file_name == "some file_name"
      assert gist.markup_text == "some markup_text"
      assert gist.user_id == scope.user.id
    end

    test "create_gist/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Gists.create_gist(scope, @invalid_attrs)
    end

    test "update_gist/3 with valid data updates the gist" do
      scope = user_scope_fixture()
      gist = gist_fixture(scope)
      update_attrs = %{description: "some updated description", file_name: "some updated file_name", markup_text: "some updated markup_text"}

      assert {:ok, %Gist{} = gist} = Gists.update_gist(scope, gist, update_attrs)
      assert gist.description == "some updated description"
      assert gist.file_name == "some updated file_name"
      assert gist.markup_text == "some updated markup_text"
    end

    test "update_gist/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      gist = gist_fixture(scope)

      assert_raise MatchError, fn ->
        Gists.update_gist(other_scope, gist, %{})
      end
    end

    test "update_gist/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      gist = gist_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Gists.update_gist(scope, gist, @invalid_attrs)
      assert gist == Gists.get_gist!(scope, gist.id)
    end

    test "delete_gist/2 deletes the gist" do
      scope = user_scope_fixture()
      gist = gist_fixture(scope)
      assert {:ok, %Gist{}} = Gists.delete_gist(scope, gist)
      assert_raise Ecto.NoResultsError, fn -> Gists.get_gist!(scope, gist.id) end
    end

    test "delete_gist/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      gist = gist_fixture(scope)
      assert_raise MatchError, fn -> Gists.delete_gist(other_scope, gist) end
    end

    test "change_gist/2 returns a gist changeset" do
      scope = user_scope_fixture()
      gist = gist_fixture(scope)
      assert %Ecto.Changeset{} = Gists.change_gist(scope, gist)
    end
  end
end
