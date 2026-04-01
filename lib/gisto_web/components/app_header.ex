defmodule GistoWeb.Components.AppHeader do
  use GistoWeb, :html
  import GistoWeb.Components.NavMenu

  def app_header(assigns) do
    ~H"""
    <header class="navbar fixed z-50 top-0 flex justify-between bg-base-300 px-4 sm:px-6 lg:px-8">
      <div class="flex items-center gap-4">
        <a href="/" class="flex w-fit items-center gap-2">
          <img src={~p"/images/logo.svg"} width="46" alt="logo" />
          <span class="text-xl font-semibold">GISTO</span>
        </a>
        {render_slot(@inner_block)}
      </div>

      <.nav_menu current_scope={@current_scope} />
    </header>
    """
  end
end
