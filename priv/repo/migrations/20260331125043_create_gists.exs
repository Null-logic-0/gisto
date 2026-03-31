defmodule Gisto.Repo.Migrations.CreateGists do
  use Ecto.Migration

  def change do
    create table(:gists) do
      add :file_name, :string
      add :description, :text
      add :markup_text, :text
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:gists, [:user_id])
  end
end
