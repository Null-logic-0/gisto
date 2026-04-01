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

  defp broadcast_gist(message, targets)

  defp broadcast_gist(message, targets) do
    Enum.each(targets, fn
      :global ->
        Phoenix.PubSub.broadcast(Gisto.PubSub, "gists", message)

      {:user, %Scope{} = scope} ->
        key = scope.user.id
        Phoenix.PubSub.broadcast(Gisto.PubSub, "user:#{key}:gists", message)
    end)

    :ok
  end

  @doc """
  Returns the list of gists.

  ## Examples

      iex> list_gists(scope)
      [%Gist{}, ...]

  """
  def list_gists(%Scope{} = scope) do
    Gist
    |> where(user_id: ^scope.user.id)
    |> order_by([g], desc: g.inserted_at)
    |> Repo.all()
    |> Repo.preload(user: :gists)
  end

  def list_all_gists(params \\ %{}) do
    search = Map.get(params, "search", nil)

    Gist
    |> search_by(search)
    |> order_by([g], desc: g.inserted_at)
    |> Repo.all()
    |> Repo.preload(user: :gists)
  end

  defp search_by(query, search) when search in ["", nil], do: query

  defp search_by(query, search) when is_binary(search) do
    where(
      query,
      [r],
      ilike(r.file_name, ^"%#{search}%") or
        ilike(r.description, ^"%#{search}%")
    )
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
      broadcast_gist({:created, gist}, [:global, {:user, scope}])
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
      broadcast_gist({:updated, gist}, [:global, {:user, scope}])
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
      broadcast_gist({:deleted, gist}, [:global, {:user, scope}])
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

  alias Gisto.Gists.SavedGist
  alias Gisto.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any saved_gist changes.

  The broadcasted messages match the pattern:

    * {:created, %SavedGist{}}
    * {:updated, %SavedGist{}}
    * {:deleted, %SavedGist{}}

  """
  def subscribe_saved_gists(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Gisto.PubSub, "user:#{key}:saved_gists")
  end

  defp broadcast_saved_gist(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Gisto.PubSub, "user:#{key}:saved_gists", message)
  end

  @doc """
  Returns the list of saved_gists.

  ## Examples

      iex> list_saved_gists(scope)
      [%SavedGist{}, ...]

  """

  def list_saved_gists(%Scope{} = scope) do
    query =
      from sg in SavedGist,
        where: sg.user_id == ^scope.user.id,
        preload: [:gist]

    Repo.all(query)
  end

  @doc """
  Gets a single saved_gist.

  Raises `Ecto.NoResultsError` if the Saved gist does not exist.

  ## Examples

      iex> get_saved_gist!(scope, 123)
      %SavedGist{}

      iex> get_saved_gist!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_saved_gist!(%Scope{} = scope, id) do
    SavedGist
    |> where([sg], sg.id == ^id and sg.user_id == ^scope.user.id)
    |> preload(:gist)
    |> Repo.one!()
  end

  @doc """
  Toggles saved or unsaved gists .

  ## Examples

      iex> toggle_saved_gist(scope, gist)


  """
  def toggle_saved_gist(%Scope{} = scope, %Gisto.Gists.Gist{} = gist) do
    existing =
      Repo.get_by(SavedGist, user_id: scope.user.id, gist_id: gist.id)

    if existing do
      {:ok, _} = Repo.delete(existing)
      broadcast_saved_gist(scope, {:deleted, existing})
      {:removed, existing}
    else
      %SavedGist{}
      |> SavedGist.changeset(%{}, scope, gist)
      |> Repo.insert()
      |> case do
        {:ok, saved_gist} ->
          broadcast_saved_gist(scope, {:created, saved_gist})
          {:added, saved_gist}

        {:error, changeset} ->
          {:error, changeset}
      end
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking saved_gist changes.

  ## Examples

      iex> change_saved_gist(scope, saved_gist)
      %Ecto.Changeset{data: %SavedGist{}}

  """
  def change_saved_gist(
        %Scope{} = scope,
        %SavedGist{} = saved_gist,
        attrs \\ %{}
      ) do
    true = saved_gist.user_id == scope.user.id

    SavedGist.changeset(saved_gist, attrs, scope, saved_gist.gist)
  end
end
