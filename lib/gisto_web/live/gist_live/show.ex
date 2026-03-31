defmodule GistoWeb.GistLive.Show do
  use GistoWeb, :live_view
  import GistoWeb.GistLive.GistCardComponent

  alias Gisto.Gists

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Gists.subscribe_gists(socket.assigns.current_scope)
    end

    socket =
      socket
      |> assign(:page_title, "Show Gist")
      |> assign(:gist, Gists.get_gist!(socket.assigns.current_scope, id))

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
        {:updated, %Gisto.Gists.Gist{id: id} = gist},
        %{assigns: %{gist: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :gist, gist)}
  end

  def handle_info({type, %Gisto.Gists.Gist{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
