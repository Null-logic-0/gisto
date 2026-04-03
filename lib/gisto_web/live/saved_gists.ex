defmodule GistoWeb.SavedGists do
  use GistoWeb, :live_view
  # import GistoWeb.Gist.GistCard
  require Logger

  alias Gisto.Gists
  alias Gisto.Gists.SavedGist

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.live_component
        module={GistoWeb.Gist.GistList}
        id="saved-gists"
        current_scope={@current_scope}
        base_path={~p"/saved-gists"}
        fetch_fn={fn params -> Gists.list_saved_gists(@current_scope, params) end}
      />
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if connected?(socket) do
      Gists.subscribe_saved_gists(current_scope)
    end

    socket =
      socket
      |> assign(page_title: "#{current_scope.user.username}'s saved gists")

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, :current_path, URI.parse(uri).path)}
  end

  @impl true
  def handle_info({type, %SavedGist{} = saved_gist}, socket)
      when type in [:created, :deleted] do
    gist = Gists.get_gist!(socket.assigns.current_scope, saved_gist.gist_id)
    send_update(GistoWeb.Gist.GistList, id: "saved-gists", event: {type, gist})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:push_patch, url}, socket) do
    {:noreply, push_patch(socket, to: url)}
  end
end
