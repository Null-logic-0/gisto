defmodule GistoWeb.Components.NavMenu do
  use GistoWeb, :html
  import GistoWeb.Components.UserDropdown

  def nav_menu(assigns) do
    ~H"""
    <nav>
      <ul class="flex gap-4 items-center">
        <%= if @current_scope do %>
          <li>
            <.button navigate={~p"/gists/new"} class="cursor-pointer">
              <.icon name="hero-plus" class="size-5 opacity-75 hover:opacity-100" />
            </.button>
          </li>
        <% end %>
        <.user_dropdown>
          <%= if @current_scope do %>
            <li class="text-center pb-2">
              {@current_scope.user.username}
            </li>
            <hr />
            <li class="pt-2 font-sm font-medium hover:text-primary transition-colors">
              <.link navigate={~p"/gists"}>{@current_scope.user.username}'s gists</.link>
            </li>
            <li class="pt-2 font-sm font-medium hover:text-primary transition-colors">
              <%!-- <.link navigate={~p"/saved-gists"}>{@current_scope.user.username}'s saved gists</.link> --%>
            </li>
            <li class="pt-2 font-sm font-medium hover:text-primary transition-colors">
              <.link navigate={~p"/users/settings"}>Settings</.link>
            </li>
            <li class="font-sm font-medium hover:text-error transition-colors">
              <.link
                href={~p"/users/log-out"}
                method="delete"
                class="font-sm font-medium hover:text-error transition-colors"
              >
                Log out
              </.link>
            </li>
          <% else %>
            <li class="font-sm font-medium hover:text-primary transition-colors">
              <.link navigate={~p"/users/register"}>Register</.link>
            </li>
            <li class="font-sm font-medium hover:text-primary transition-colors">
              <.link navigate={~p"/users/log-in"}>Log in</.link>
            </li>
          <% end %>
        </.user_dropdown>
      </ul>
    </nav>
    """
  end
end
