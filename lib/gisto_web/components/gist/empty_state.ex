defmodule GistoWeb.Gist.EmptyState do
  use GistoWeb, :html

  def empty_state(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center py-24 text-base-content/50">
      <.icon name="hero-document-text" class="h-10 w-10 mb-4" />
      <p class="text-sm font-medium">No gists found</p>
      <p class="text-xs mt-1">
        <%= if @search not in [nil, ""] do %>
          No results for "{@search}". Try a different search.
        <% else %>
          <p class="text-lg font-medium mb-2">No gists have been created yet.</p>
          <.button variant="primary" navigate={~p"/gists/new"}>
            <.icon name="hero-plus" /> New Gist
          </.button>
        <% end %>
      </p>
    </div>
    """
  end
end
