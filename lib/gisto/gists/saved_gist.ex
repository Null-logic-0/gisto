defmodule Gisto.Gists.SavedGist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "saved_gists" do
    belongs_to :user, Gisto.Accounts.User
    belongs_to :gist, Gisto.Gists.Gist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(saved_gist, attrs, user_scope, gist) do
    saved_gist
    |> cast(attrs, [])
    |> validate_required([])
    |> put_assoc(:user, user_scope.user)
    |> put_assoc(:gist, gist)
    |> unique_constraint([:user_id, :gist_id])
  end
end
