defmodule GistoWeb.Gist.Search do
  use GistoWeb, :html

  def search(assigns) do
    ~H"""
    <.form
      for={@form}
      id="search_form"
      phx-change="search"
      phx-target={@target}
      class="relative w-full"
    >
      <.input
        type="search"
        field={@form[:search]}
        placeholder="Search..."
        autocomplete="off"
        phx-debounce="500"
      />

      <.icon name="hero-magnifying-glass" class="size-4 absolute top-1/3 right-3" />
    </.form>
    """
  end
end
