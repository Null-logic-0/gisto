defmodule GistoWeb.Gist.Form.CodeEditor do
  use GistoWeb, :html

  def code_editor(assigns) do
    ~H"""
    <div class="relative flex rounded-b-2xl overflow-scroll bg-base-100 min-h-[320px]">
      <div
        id="line-numbers"
        class="select-none text-right px-3 space-y-1.5 py-4 font-mono text-xs text-base-content/25 bg-base-200/60 border-r border-base-300 leading-relaxed min-w-[3rem] min-h-[320px] h-full overflow-scroll"
        aria-hidden="true"
      >
        <div>1</div>
      </div>

      <div class="relative flex-1">
        <.input
          field={@form[:markup_text]}
          type="textarea"
          placeholder="Paste or type your code here..."
          autocomplete="off"
          phx-debounce="blur"
          id="code-editor"
          class="textarea font-mono text-sm w-full h-full min-h-[320px] border-none rounded-none focus:outline-none resize-none bg-base-100 p-4 leading-relaxed text-base-content/90 caret-primary"
          phx-hook="LineNumbers"
        />
      </div>
    </div>
    """
  end
end
