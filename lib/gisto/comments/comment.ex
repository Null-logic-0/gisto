defmodule Gisto.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :comment, :string
    belongs_to :user, Gisto.Accounts.User
    belongs_to :gist, Gisto.Gists.Gist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs, user_scope, gist) do
    comment
    |> cast(attrs, [:comment])
    |> validate_required([:comment])
    |> put_change(:user_id, user_scope.user.id)
    |> put_change(:gist_id, gist.id)
  end
end
