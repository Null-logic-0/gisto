defmodule GistoWeb.GistLive.GistBookmarkButton do
  use GistoWeb, :live_component
  alias Gisto.Gists

  def update(assigns, socket) do
    gist = assigns.gist
    current_scope = assigns.current_scope

    saved? = Gists.gist_saved?(current_scope, gist)
    gist = %{gist | saved?: saved?}

    {:ok, assign(socket, assigns) |> assign(:gist, gist)}
  end

  def render(assigns) do
    ~H"""
    <button
      phx-click="save-gist"
      phx-value-id={@gist.id}
      phx-target={@myself}
      type="button"
      class="cursor-pointer"
    >
      <.icon name={if @gist.saved?, do: "hero-bookmark-solid", else: "hero-bookmark"} />
    </button>
    """
  end

  def handle_event("save-gist", %{"id" => id}, socket) do
    current_scope = socket.assigns.current_scope
    gist = Gists.get_gist!(current_scope, id)

    case Gists.toggle_saved_gist(current_scope, gist) do
      {:added, _} -> {:noreply, assign(socket, :gist, %{gist | saved?: true})}
      {:removed, _} -> {:noreply, assign(socket, :gist, %{gist | saved?: false})}
      {:error, _} -> {:noreply, socket}
    end
  end
end
