defmodule GistoWeb.Gist.Pagination do
  use GistoWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center gap-1 mt-10">
      <button
        class="btn btn-sm btn-ghost"
        phx-click="goto_page"
        phx-value-page={@page - 1}
        phx-target={@target}
        disabled={@page == 1}
      >
        <.icon name="hero-chevron-left" class="h-4 w-4" />
      </button>

      <%= for page_num <- page_range(@page, @total_pages) do %>
        <%= if page_num == :ellipsis do %>
          <span class="px-2 text-base-content/30">…</span>
        <% else %>
          <button
            class={"btn btn-sm #{if page_num == @page, do: "btn-primary", else: "btn-ghost"}"}
            phx-click="goto_page"
            phx-value-page={page_num}
            phx-target={@target}
          >
            {page_num}
          </button>
        <% end %>
      <% end %>

      <button
        class="btn btn-sm btn-ghost"
        phx-click="goto_page"
        phx-value-page={@page + 1}
        phx-target={@target}
        disabled={@page == @total_pages}
      >
        <.icon name="hero-chevron-right" class="h-4 w-4" />
      </button>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:page_range, page_range(assigns.page, assigns.total_pages))}
  end

  defp page_range(_current, total) when total <= 7, do: Enum.to_list(1..total)

  defp page_range(current, total) do
    cond do
      current <= 4 -> Enum.to_list(1..5) ++ [:ellipsis, total]
      current >= total - 3 -> [1, :ellipsis] ++ Enum.to_list((total - 4)..total)
      true -> [1, :ellipsis] ++ Enum.to_list((current - 1)..(current + 1)) ++ [:ellipsis, total]
    end
  end
end
