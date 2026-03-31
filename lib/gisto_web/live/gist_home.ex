defmodule GistoWeb.GistHome do
  use GistoWeb, :live_view
  import GistoWeb.GistLive.GistCardComponent
  alias Gisto.Gists

  on_mount {GistoWeb.UserAuth, :mount_current_scope}

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        <h1 class="text-3xl font-semibold">
          All Gists
        </h1>
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

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Gists.subscribe_gists(socket.assigns.current_scope)
    end

    socket =
      socket
      |> assign(:page_title, "All Gists")
      |> stream(:gists, Gists.list_gists())

    {:ok, socket}
  end
end
