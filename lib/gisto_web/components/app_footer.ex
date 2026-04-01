defmodule GistoWeb.Components.AppFooter do
  use GistoWeb, :html

  def app_footer(assigns) do
    ~H"""
    <footer class="w-full text-xs mt-24">
      <div class="border-t-[1px] border-base-500 w-full"></div>
      <div class="w-full flex justify-between  items-center py-6">
        <div class="flex items-center gap-4">
          <img src="/images/logo.svg" alt="Logo" width="36" />
          <span>
            © {Date.utc_today().year} Luka Tchelidze. All rights reserved.
          </span>
        </div>
        <div>
          {render_slot(@inner_block)}
        </div>
      </div>
    </footer>
    """
  end
end
