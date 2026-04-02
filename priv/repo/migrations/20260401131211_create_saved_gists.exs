defmodule Gisto.Repo.Migrations.CreateSavedGists do
  use Ecto.Migration

  def change do
    create table(:saved_gists) do
      add :gist_id, references(:gists, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:saved_gists, [:user_id])
    create index(:saved_gists, [:gist_id])
    create unique_index(:saved_gists, [:user_id, :gist_id])
  end
end
