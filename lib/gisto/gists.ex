defmodule Gisto.Gists do
  @moduledoc """
  The Gists context.
  """

  import Ecto.Query, warn: false
  alias Gisto.Repo

  alias Gisto.Gists.Gist
  alias Gisto.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any gist changes.

  The broadcasted messages match the pattern:

    * {:created, %Gist{}}
    * {:updated, %Gist{}}
    * {:deleted, %Gist{}}

  """
  def subscribe_gists(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Gisto.PubSub, "user:#{key}:gists")
  end

  def subscribe_gists(nil), do: :ok

  def subscribe_gists do
    Phoenix.PubSub.subscribe(Gisto.PubSub, "gists")
  end

  # defp broadcast_gist(message) do
  #   Phoenix.PubSub.broadcast(Gisto.PubSub, "gists", message)
  # end

  defp broadcast_gist(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Gisto.PubSub, "user:#{key}:gists", message)
  end

  @doc """
  Returns the list of gists.

  ## Examples

      iex> list_gists(scope)
      [%Gist{}, ...]

  """
  def list_gists(%Scope{} = scope) do
    Repo.all_by(Gist, user_id: scope.user.id)
    |> Repo.preload(user: :gists)
  end

  def list_gists() do
    Repo.all(Gist)
    |> Repo.preload(user: :gists)
  end

  @doc """
  Gets a single gist.

  Raises `Ecto.NoResultsError` if the Gist does not exist.

  ## Examples

      iex> get_gist!(scope, 123)
      %Gist{}

      iex> get_gist!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_gist!(%Scope{} = _scope, id) do
    Repo.get!(Gist, id)
    |> Repo.preload(user: :gists)
  end

  @doc """
  Creates a gist.

  ## Examples

      iex> create_gist(scope, %{field: value})
      {:ok, %Gist{}}

      iex> create_gist(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gist(%Scope{} = scope, attrs) do
    with {:ok, gist = %Gist{}} <-
           %Gist{}
           |> Gist.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_gist(scope, {:created, gist})
      {:ok, gist}
    end
  end

  @doc """
  Updates a gist.

  ## Examples

      iex> update_gist(scope, gist, %{field: new_value})
      {:ok, %Gist{}}

      iex> update_gist(scope, gist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gist(%Scope{} = scope, %Gist{} = gist, attrs) do
    true = gist.user_id == scope.user.id

    with {:ok, gist = %Gist{}} <-
           gist
           |> Gist.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_gist(scope, {:updated, gist})
      {:ok, gist}
    end
  end

  @doc """
  Deletes a gist.

  ## Examples

      iex> delete_gist(scope, gist)
      {:ok, %Gist{}}

      iex> delete_gist(scope, gist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gist(%Scope{} = scope, %Gist{} = gist) do
    true = gist.user_id == scope.user.id

    with {:ok, gist = %Gist{}} <-
           Repo.delete(gist) do
      broadcast_gist(scope, {:deleted, gist})
      {:ok, gist}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gist changes.

  ## Examples

      iex> change_gist(scope, gist)
      %Ecto.Changeset{data: %Gist{}}

  """
  def change_gist(%Scope{} = scope, %Gist{} = gist, attrs \\ %{}) do
    true = gist.user_id == scope.user.id

    Gist.changeset(gist, attrs, scope)
  end
end
