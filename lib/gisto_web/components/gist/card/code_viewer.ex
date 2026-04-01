defmodule GistoWeb.Gist.Card.CodeViewer do
  use GistoWeb, :html

  def code_viewer(assigns) do
    ~H"""
    <div class="flex overflow-x-auto">
      <div
        id="line-numbers"
        class="select-none text-right px-3 py-4 space-y-1.5 font-mono text-xs text-base-content/25 bg-base-200/60 border-r border-base-300 leading-relaxed min-w-[3rem]"
        aria-hidden="true"
      >
        <div>1</div>
      </div>

      <pre
        id="gist-raw"
        phx-hook="LineNumbers"
        data-filename={@gist.file_name}
        class="flex-1 font-mono text-sm p-4 leading-6 text-base-content/85 overflow-x-auto whitespace-pre bg-base-100"
      >{@gist.markup_text}
     </pre>
    </div>
    """
  end
end
