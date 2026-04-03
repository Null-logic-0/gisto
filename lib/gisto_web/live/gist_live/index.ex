defmodule GistoWeb.GistLive.Index do
  use GistoWeb, :live_view
  # import GistoWeb.Gist.GistCard

  alias Gisto.Gists

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.live_component
        module={GistoWeb.Gist.GistList}
        id="gist-list"
        current_scope={@current_scope}
        base_path={~p"/gists"}
        fetch_fn={fn params -> Gists.list_gists(@current_scope, params) end}
      />
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Gists.subscribe_gists(socket.assigns.current_scope)
    end

    socket =
      socket
      |> assign(:page_title, "#{socket.assigns.current_scope.user.username}'s Gists")

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, :current_path, URI.parse(uri).path)}
  end

  @impl true
  def handle_info({type, %Gisto.Gists.Gist{} = gist}, socket)
      when type in [:created, :updated, :deleted] do
    send_update(GistoWeb.Gist.GistList, id: "gist-list", event: {type, gist})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:push_patch, url}, socket) do
    {:noreply, push_patch(socket, to: url)}
  end
end
