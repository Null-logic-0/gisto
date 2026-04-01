defmodule GistoWeb.Gist.Form.FileNameInput do
  use GistoWeb, :html

  def file_name_input(assigns) do
    ~H"""
    <div class="flex items-center gap-2 px-4 py-3 border-b border-base-300 bg-base-200/50 rounded-t-2xl">
      <div class="flex-1">
        <.input
          field={@form[:file_name]}
          type="text"
          placeholder="filename.ex"
          autocomplete="off"
          phx-debounce="blur"
          class="input input-sm bg-base-100 border border-base-300 font-mono text-sm w-full max-w-xs focus:outline-none focus:border-primary"
        />
      </div>

      <div class="badge badge-outline badge-sm font-mono opacity-60">
        {String.split(@form[:file_name].value || "untitled.txt", ".") |> List.last()}
      </div>
    </div>
    """
  end
end
