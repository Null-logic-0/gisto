defmodule GistoWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use GistoWeb, :html
  import GistoWeb.CustomComponents

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :current_path, :string, required: false

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar fixed z-50 top-0 flex justify-between bg-base-300 px-4 sm:px-6 lg:px-8">
      <div class="flex items-center gap-4">
        <a href="/" class="flex w-fit items-center gap-2">
          <img src={~p"/images/logo.svg"} width="46" alt="logo" />
          <span class="text-xl font-semibold">GISTO</span>
        </a>
        <.link
          navigate={~p"/"}
          class={
            "font-sm font-medium transition-colors " <>
              if Map.get(assigns, :current_path, nil) == "/", do: "text-primary", else: "hover:text-primary"
          }
        >
          All Gists
        </.link>
      </div>

      <ul class="flex   gap-4 items-center">
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
    </header>

    <.banner title="Instantly share code, notes, and snippets." />

    <div class="mx-auto max-w-5xl  space-y-4 px-4 py-6 sm:px-6 lg:px-8">
      <main>
        {render_slot(@inner_block)}
      </main>
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
            <.theme_toggle />
          </div>
        </div>
      </footer>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
