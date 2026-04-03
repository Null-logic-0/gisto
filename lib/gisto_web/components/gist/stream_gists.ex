defmodule GistoWeb.Gist.StreamGists do
  use Phoenix.Component
  import GistoWeb.Gist.GistCard

  def stream_gists(assigns) do
    ~H"""
    <div id="gists" phx-update="stream" class="grid grid-cols-1 gap-8">
      <div
        :for={{id, gist} <- @stream}
        id={id}
        class="overflow-y-hidden border-b border-base-300 max-h-[320px]"
      >
        <.gist_card gist={gist} current_scope={@current_scope} />
      </div>
    </div>
    """
  end
end
