defmodule GistoWeb.Gist.ErrorState do
  use GistoWeb, :html

  def error_state(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center py-24 text-error">
      <.icon name="hero-exclamation-circle" class="h-10 w-10 mb-4" />
      <p class="text-sm font-medium">Oops...Something went wrong</p>
      <p class="text-xs text-base-content/50 mt-1">{@error}</p>
      <button
        class="btn btn-sm btn-outline btn-error mt-6"
        phx-click="retry"
        phx-target={@myself}
      >
        Try again
      </button>
    </div>
    """
  end
end
