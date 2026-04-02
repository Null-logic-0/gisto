defmodule GistoWeb.SavedGists do
  use GistoWeb, :live_view
  import GistoWeb.Gist.GistCard
  require Logger

  alias Gisto.Gists
  alias Gisto.Gists.SavedGist

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div id="saved-gists" phx-update="stream" class="grid grid-cols-1 gap-8">
        <div
          :for={{id, saved_gist} <- @streams.saved_gists}
          id={id}
          class="overflow-y-hidden border-b border-base-300 max-h-[320px]"
        >
          <.gist_card gist={saved_gist} current_scope={@current_scope} />
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if connected?(socket) do
      Gists.subscribe_saved_gists(current_scope)
    end

    saved_gists = Gists.list_saved_gists(current_scope)

    socket =
      socket
      |> assign(page_title: "#{current_scope.user.username}'s saved gists")
      |> stream(:saved_gists, saved_gists)

    {:ok, socket}
  end

  @impl true
  def handle_info({:created, %SavedGist{} = saved_gist}, socket) do
    gist = Gists.get_gist!(socket.assigns.current_scope, saved_gist.gist_id)
    {:noreply, stream_insert(socket, :saved_gists, %{gist | saved?: true})}
  end

  def handle_info({:deleted, %SavedGist{} = saved_gist}, socket) do
    gist = Gists.get_gist!(socket.assigns.current_scope, saved_gist.gist_id)
    {:noreply, stream_delete(socket, :saved_gists, gist)}
  end
end
