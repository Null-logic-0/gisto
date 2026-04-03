defmodule GistoWeb.Gist.Loading do
  use GistoWeb, :html

  def loading(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center py-24 text-base-content/50">
      <span class="loading loading-spinner loading-xl mb-4"></span>
      <p class="text-sm text-center animate-pulse">{@fallback_text}</p>
    </div>
    """
  end
end
