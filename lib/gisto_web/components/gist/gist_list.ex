defmodule GistoWeb.Gist.GistList do
  use GistoWeb, :live_component
  import GistoWeb.Gist.StreamGists
  import GistoWeb.Gist.Search
  import GistoWeb.Gist.Loading
  import GistoWeb.Gist.ErrorState
  import GistoWeb.Gist.EmptyState
  alias Gisto.Gists

  @per_page 10

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id}>
      <div class="mx-auto mb-12 w-full max-w-2xl">
        <.search form={@form} target={@myself} />
      </div>

      <%= cond do %>
        <% @loading -> %>
          <.loading fallback_text="Loading Gists..." />
        <% @error -> %>
          <.error_state error={@error} myself={@myself} />
        <% @empty -> %>
          <.empty_state search={@search} />
        <% true -> %>
          <.stream_gists stream={@streams.gists} current_scope={@current_scope} />

          <.live_component
            :if={@total_pages > 1}
            module={GistoWeb.Gist.Pagination}
            id="pagination"
            page={@page}
            total_pages={@total_pages}
            target={@myself}
          />
      <% end %>
    </div>
    """
  end

  @impl true
  def update(%{event: {type, %Gists.Gist{} = _gist}}, socket)
      when type in [:created, :updated] do
    {:ok, schedule_load(socket, socket.assigns.params, socket.assigns.page)}
  end

  def update(%{event: {:deleted, gist}}, socket) do
    {:ok, stream_delete(socket, :gists, gist)}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:params, fn -> %{} end)
      |> assign_new(:search, fn -> nil end)
      |> assign_new(:form, fn -> to_form(%{}) end)
      |> assign_new(:loading, fn -> false end)
      |> assign_new(:error, fn -> nil end)
      |> assign_new(:empty, fn -> false end)
      |> assign_new(:page, fn -> 1 end)
      |> assign_new(:total_pages, fn -> 1 end)
      |> assign_new(:base_path, fn -> "/" end)

    socket =
      if not assigned?(socket, :gists_loaded) do
        schedule_load(socket, socket.assigns.params, 1)
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("search", params, socket) do
    params =
      params
      |> Map.take(~w(search))
      |> Enum.reject(fn {_k, v} -> v == "" end)
      |> Enum.into(%{})

    url =
      if map_size(params) > 0,
        do: "#{socket.assigns.base_path}?#{URI.encode_query(params)}",
        else: socket.assigns.base_path

    send(self(), {:push_patch, url})

    {:noreply, schedule_load(socket, params, 1)}
  end

  def handle_event("goto_page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    params = socket.assigns.params
    base_path = socket.assigns.base_path

    url =
      if map_size(params) > 0 do
        "#{base_path}?#{URI.encode_query(Map.put(params, "page", page))}"
      else
        "#{base_path}?page=#{page}"
      end

    send(self(), {:push_patch, url})

    {:noreply, schedule_load(socket, params, page)}
  end

  def handle_event("retry", _params, socket) do
    {:noreply, schedule_load(socket, socket.assigns.params, socket.assigns.page)}
  end

  @impl true
  def handle_async(:load_gists, {:ok, %{gists: gists, total: total, page: page}}, socket) do
    params = socket.assigns.params
    total_pages = max(1, ceil(total / @per_page))

    {:noreply,
     socket
     |> assign(:gists_loaded, true)
     |> assign(:search, params["search"])
     |> assign(:form, to_form(params))
     |> assign(:loading, false)
     |> assign(:error, nil)
     |> assign(:page, page)
     |> assign(:total_pages, total_pages)
     |> assign(:empty, Enum.empty?(gists))
     |> stream(:gists, gists, reset: true)}
  end

  def handle_async(:load_gists, {:exit, reason}, socket) do
    params = socket.assigns.params

    {:noreply,
     socket
     |> assign(:gists_loaded, true)
     |> assign(:search, params["search"])
     |> assign(:form, to_form(params))
     |> assign(:loading, false)
     |> assign(:empty, false)
     |> assign(:error, inspect(reason))}
  end

  defp schedule_load(socket, params, page) do
    fetch_fn = socket.assigns.fetch_fn

    socket
    |> assign(:params, params)
    |> assign(:page, page)
    |> assign(:loading, true)
    |> assign(:gists_loaded, false)
    |> start_async(:load_gists, fn ->
      # Process.sleep(6000)
      # raise "Something went wrong"
      fetch_fn.(Map.put(params, "page", Integer.to_string(page)))
    end)
  end

  defp assigned?(socket, key), do: Map.has_key?(socket.assigns, key)
end
