defmodule GistoWeb.Components.UserDropdown do
  use GistoWeb, :html

  @doc """
  User dropdown menu with Settings and Log out links.
  """
  slot :inner_block, required: true

  def user_dropdown(assigns) do
    ~H"""
    <div class="dropdown dropdown-end ">
      <div tabindex="0" role="button" class="cursor-pointer">
        <.icon name="hero-user-circle" class="size-6 opacity-75 hover:opacity-100" />
      </div>
      <ul
        tabindex="-1"
        class="menu dropdown-content bg-base-200 rounded-box z-1 w-52 p-2 mt-3 shadow-sm"
      >
        {render_slot(@inner_block)}
      </ul>
    </div>
    """
  end
end
