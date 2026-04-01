defmodule GistoWeb.Gist.Form.DescriptionInput do
  use GistoWeb, :html

  def description_input(assigns) do
    ~H"""
    <div class="form-control">
      <label class="label pb-1">
        <span class="label-text font-medium text-sm">Description</span>
        <span class="label-text-alt text-base-content/40">optional</span>
      </label>
      <.input
        field={@form[:description]}
        type="textarea"
        placeholder="What does this snippet do? Add context or usage notes..."
        autocomplete="off"
        phx-debounce="blur"
        class="textarea textarea-bordered text-sm min-h-[96px] focus:textarea-primary resize-none"
      />
    </div>
    """
  end
end
