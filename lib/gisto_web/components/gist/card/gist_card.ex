defmodule GistoWeb.Gist.GistCard do
  use GistoWeb, :html

  import GistoWeb.Gist.Card.GistCardHeader
  import GistoWeb.Gist.Card.GistInfoBar
  import GistoWeb.Gist.Card.CodeViewer

  def gist_card(assigns) do
    ~H"""
    <div class="space-y-2">
      <.gist_card_header gist={@gist} />

      <div class="card border border-base-300 shadow-sm overflow-hidden bg-base-100">
        <.gist_info_bar gist={@gist} />
        <.code_viewer gist={@gist} />
      </div>
    </div>
    """
  end
end
