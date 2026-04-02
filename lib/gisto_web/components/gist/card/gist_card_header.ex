defmodule GistoWeb.Gist.Card.GistCardHeader do
  use GistoWeb, :html

  def gist_card_header(assigns) do
    ~H"""
    <div class="min-w-0">
      <div class="flex items-center justify-between flex-wrap">
        <h1 class="text-lg font-bold font-mono ">
          {@gist.user.username} /
          <.link navigate={~p"/gists/#{@gist}"} class="text-info hover:underline">
            {@gist.file_name}
          </.link>
        </h1>
        <div>
          <div class="badge badge-primary badge-sm">
            {String.split(@gist.file_name || "txt", ".") |> List.last() |> String.upcase()}
          </div>
          <div class="badge badge-info badge-sm gap-1">
            <.icon name="hero-eye-solid" /> Public
          </div>
          <.live_component
            module={GistoWeb.GistLive.GistBookmarkButton}
            id={"bookmark-#{@gist.id}"}
            gist={@gist}
            current_scope={@current_scope}
          />
        </div>
      </div>
      <p :if={@gist.description} class="text-sm text-base-content/50 mt-0.5 truncate">
        {@gist.description}
      </p>
      <p :if={!@gist.description} class="text-sm text-base-content/30 mt-0.5 italic">
        No description provided
      </p>
    </div>
    """
  end
end
