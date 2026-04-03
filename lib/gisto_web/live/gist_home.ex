defmodule GistoWeb.GistHome do
  use GistoWeb, :live_view
  # import GistoWeb.Gist.GistCard
  # import GistoWeb.Gist.Search

  alias Gisto.Gists

  on_mount {GistoWeb.UserAuth, :mount_current_scope}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} current_path={@current_path}>
      <.live_component
        module={GistoWeb.Gist.GistList}
        id="gist-list"
        base_path={~p"/"}
        current_scope={@current_scope}
        fetch_fn={fn params -> Gists.list_all_gists(params) end}
      />
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Gists.subscribe_gists()
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    socket =
      socket
      |> assign(:page_title, "All Gists")
      |> assign(:current_path, URI.parse(uri).path)

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", params, socket) do
    send_update(GistoWeb.GistLive.GistList, id: "gist-list", event: {:search, params})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:push_patch, url}, socket) do
    {:noreply, push_patch(socket, to: url)}
  end

  @impl true
  def handle_info({type, %Gisto.Gists.Gist{} = gist}, socket)
      when type in [:created, :updated, :deleted] do
    send_update(GistoWeb.Gist.GistList, id: "gist-list", event: {type, gist})
    {:noreply, socket}
  end
end
