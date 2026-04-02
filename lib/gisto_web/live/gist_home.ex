defmodule GistoWeb.GistHome do
  use GistoWeb, :live_view
  import GistoWeb.Gist.GistCard
  import GistoWeb.Gist.Search

  alias Gisto.Gists

  on_mount {GistoWeb.UserAuth, :mount_current_scope}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} current_path={@current_path}>
      <.header>
        <div class="mx-auto mb-12 w-full max-w-2xl">
          <.search form={@form} />
        </div>
      </.header>

      <div id="gists" phx-update="stream" class="grid grid-cols-1 gap-8">
        <div
          :for={{id, gist} <- @streams.gists}
          id={id}
          class="overflow-y-hidden border-b border-base-300 max-h-[320px]"
        >
          <.gist_card gist={gist} current_scope={@current_scope} />
        </div>
      </div>
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
  def handle_params(params, uri, socket) do
    socket =
      socket
      |> assign(:page_title, "All Gists")
      |> assign(:form, to_form(params))
      |> assign(:current_path, URI.parse(uri).path)
      |> stream(:gists, Gists.list_all_gists(params), reset: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", params, socket) do
    params =
      params
      |> Map.take(~w(search))
      |> Enum.reject(fn {_k, v} -> v == "" end)
      |> Enum.into(%{})

    url =
      if map_size(params) > 0 do
        "/?#{URI.encode_query(params)}"
      else
        "/"
      end

    {:noreply, push_patch(socket, to: url)}
  end

  @impl true
  def handle_info({type, %Gisto.Gists.Gist{}}, socket)
      when type in [:created, :updated] do
    {:noreply, stream(socket, :gists, Gists.list_all_gists(), reset: true)}
  end

  def handle_info({:deleted, gist}, socket) do
    {:noreply, stream_delete(socket, :gists, gist)}
  end
end
