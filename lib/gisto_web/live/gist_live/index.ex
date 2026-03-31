defmodule GistoWeb.GistLive.Index do
  use GistoWeb, :live_view
  import GistoWeb.GistLive.GistCardComponent

  alias Gisto.Gists

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        <h1 class="text-3xl font-semibold">
          My Gists
        </h1>
        <:actions>
          <.button variant="primary" navigate={~p"/gists/new"}>
            <.icon name="hero-plus" /> New Gist
          </.button>
        </:actions>
      </.header>

      <div
        :for={{_id, gist} <- @streams.gists}
        id="gists"
        class="grid grid-cols-1 gap-6"
      >
        <div class="overflow-y-hidden border-b  border-base-300  max-h-[320px]">
          <.gist_card gist={gist} />
        </div>
      </div>
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
      |> assign(:page_title, "My Gists")
      |> stream(:gists, list_gists(socket.assigns.current_scope))

    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    gist = Gists.get_gist!(socket.assigns.current_socpe, id)
    {:ok, _} = Gists.delete_gist(socket.assigns.current_scope, gist)

    {:noreply, stream_delete(socket, :gists, gist)}
  end

  @impl true
  def handle_info({type, %Gisto.Gists.Gist{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :gists, list_gists(socket.assigns.current_scope), reset: true)}
  end

  defp list_gists(current_scope) do
    Gists.list_gists(current_scope)
  end
end
