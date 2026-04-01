defmodule Gisto.Gists.Gist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gists" do
    field :file_name, :string
    field :description, :string
    field :markup_text, :string

    belongs_to :user, Gisto.Accounts.User
    has_many :saved_gists, Gisto.Gists.SavedGist

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gist, attrs, user_scope) do
    gist
    |> cast(attrs, [:file_name, :description, :markup_text])
    |> validate_required([:file_name, :markup_text])
    |> validate_length(:description, max: 200)
    |> put_assoc(:user, user_scope.user)
  end
end
