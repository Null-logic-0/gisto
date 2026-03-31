defmodule Gisto.GistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gisto.Gists` context.
  """

  @doc """
  Generate a gist.
  """
  def gist_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        file_name: "some file_name",
        markup_text: "some markup_text"
      })

    {:ok, gist} = Gisto.Gists.create_gist(scope, attrs)
    gist
  end
end
