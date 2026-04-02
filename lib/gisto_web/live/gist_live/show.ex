defmodule GistoWeb.GistLive.Show do
  use GistoWeb, :live_view
  import GistoWeb.Gist.GistCard
  alias Gisto.Gists
  alias Gisto.Comments

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    scope = socket.assigns.current_scope
    gist = Gists.get_gist!(scope, id)

    if connected?(socket) do
      Gists.subscribe_gists(socket.assigns.current_scope)
      Comments.subscribe_comments(gist)
    end

    socket =
      socket
      |> assign(:page_title, "#{gist.file_name}")
      |> assign(:gist, gist)
      |> assign(:comments, Comments.list_comments(gist))

    {:ok, socket}
  end

  @impl true
  def handle_event("delete", _params, socket) do
    {:ok, deleted_gist} =
      Gists.delete_gist(socket.assigns.current_scope, socket.assigns.gist)

    socket =
      socket
      |> put_flash(:info, "#{deleted_gist.file_name} deleted")
      |> push_navigate(to: ~p"/gists")

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {:updated, %Gists.Gist{id: id} = gist},
        %{assigns: %{gist: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :gist, gist)}
  end

  def handle_info({type, %Gists.Gist{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end

  def handle_info({type, %Comments.Comment{}}, socket)
      when type in [:created, :updated, :deleted] do
    send_update(GistoWeb.GistLive.GistComment,
      id: "gist-comments-#{socket.assigns.gist.id}"
    )

    {:noreply, socket}
  end
end
