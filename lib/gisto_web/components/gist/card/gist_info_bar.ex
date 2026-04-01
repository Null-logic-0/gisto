defmodule GistoWeb.Gist.Card.GistInfoBar do
  use GistoWeb, :html

  def gist_info_bar(assigns) do
    ~H"""
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
    """
  end
end
