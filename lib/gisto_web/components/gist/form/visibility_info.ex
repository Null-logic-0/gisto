defmodule GistoWeb.Gist.Form.VisibilityInfo do
  use GistoWeb, :html

  def visibility_info(assigns) do
    ~H"""
    <div class="flex items-center gap-4">
      <div class="flex items-center gap-2 text-sm text-base-content/60">
        <.icon name="hero-eye-solid" class="size-4" /> Public gist  visible to everyone
      </div>
    </div>
    """
  end
end
