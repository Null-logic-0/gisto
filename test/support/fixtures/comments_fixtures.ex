defmodule Gisto.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gisto.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(scope, gist, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        comment: "some comment"
      })

    {:ok, comment} = Gisto.Comments.create_comment(scope, gist, attrs)
    comment
  end
end
