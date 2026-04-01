defmodule GistoWeb.GistLive.GistCardComponent do
  use GistoWeb, :html

  def gist_card(assigns) do
    ~H"""
    <div class="space-y-2">
      <div class="min-w-0">
        <div class="flex items-center gap-3 flex-wrap">
          <h1 class="text-lg font-bold font-mono ">
            {@gist.user.username} /
            <.link navigate={~p"/gists/#{@gist}"} class="text-info hover:underline">
              {@gist.file_name}
            </.link>
          </h1>
          <div class="badge badge-primary badge-sm">
            {String.split(@gist.file_name || "txt", ".") |> List.last() |> String.upcase()}
          </div>
          <div class="badge badge-info badge-sm gap-1">
            <.icon name="hero-eye-solid" /> Public
          </div>
        </div>
        <p :if={@gist.description} class="text-sm text-base-content/50 mt-0.5 truncate">
          {@gist.description}
        </p>
        <p :if={!@gist.description} class="text-sm text-base-content/30 mt-0.5 italic">
          No description provided
        </p>
      </div>

      <div class="card border border-base-300 shadow-sm overflow-hidden bg-base-100">
        <div class="flex items-center justify-between px-4 py-2.5 bg-base-200/70 border-b border-base-300">
          <span class="font-mono text-xs text-base-content/40 ml-2">
            {@gist.file_name}
          </span>

          <div class="flex items-center gap-3 text-xs text-base-content/35 font-mono">
            <span>{@gist.markup_text |> String.split("\n") |> length()} lines</span>
            <span>·</span>
            <span>{byte_size(@gist.markup_text || "")} bytes</span>
          </div>
        </div>

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
      </div>
    </div>
    """
  end
end
