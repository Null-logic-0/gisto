defmodule Gisto.CommentsTest do
  use Gisto.DataCase

  alias Gisto.Comments

  describe "comments" do
    alias Gisto.Comments.Comment

    import Gisto.AccountsFixtures, only: [user_scope_fixture: 0]
    import Gisto.CommentsFixtures

    @invalid_attrs %{comment: nil}

    test "list_comments/1 returns all scoped comments" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      comment = comment_fixture(scope)
      other_comment = comment_fixture(other_scope)
      assert Comments.list_comments(scope) == [comment]
      assert Comments.list_comments(other_scope) == [other_comment]
    end

    test "get_comment!/2 returns the comment with given id" do
      scope = user_scope_fixture()
      comment = comment_fixture(scope)
      other_scope = user_scope_fixture()
      assert Comments.get_comment!(scope, comment.id) == comment
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(other_scope, comment.id) end
    end

    test "create_comment/2 with valid data creates a comment" do
      valid_attrs = %{comment: "some comment"}
      scope = user_scope_fixture()

      assert {:ok, %Comment{} = comment} = Comments.create_comment(scope, valid_attrs)
      assert comment.comment == "some comment"
      assert comment.user_id == scope.user.id
    end

    test "create_comment/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(scope, @invalid_attrs)
    end

    test "update_comment/3 with valid data updates the comment" do
      scope = user_scope_fixture()
      comment = comment_fixture(scope)
      update_attrs = %{comment: "some updated comment"}

      assert {:ok, %Comment{} = comment} = Comments.update_comment(scope, comment, update_attrs)
      assert comment.comment == "some updated comment"
    end

    test "update_comment/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      comment = comment_fixture(scope)

      assert_raise MatchError, fn ->
        Comments.update_comment(other_scope, comment, %{})
      end
    end

    test "update_comment/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      comment = comment_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(scope, comment, @invalid_attrs)
      assert comment == Comments.get_comment!(scope, comment.id)
    end

    test "delete_comment/2 deletes the comment" do
      scope = user_scope_fixture()
      comment = comment_fixture(scope)
      assert {:ok, %Comment{}} = Comments.delete_comment(scope, comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(scope, comment.id) end
    end

    test "delete_comment/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      comment = comment_fixture(scope)
      assert_raise MatchError, fn -> Comments.delete_comment(other_scope, comment) end
    end

    test "change_comment/2 returns a comment changeset" do
      scope = user_scope_fixture()
      comment = comment_fixture(scope)
      assert %Ecto.Changeset{} = Comments.change_comment(scope, comment)
    end
  end
end
