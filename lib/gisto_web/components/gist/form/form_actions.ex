defmodule GistoWeb.Gist.Form.FormActions do
  use GistoWeb, :html

  def form_actions(assigns) do
    ~H"""
    <div class="flex items-center justify-between pt-2 border-t border-base-300">
      <.button
        phx-disable-with="Saving..."
        class="btn btn-primary gap-2"
      >
        <.icon name="hero-cloud-arrow-up" class="size-4" /> Save Gist
      </.button>

      <.button
        navigate={@return_path}
        class="btn btn-ghost  "
      >
        Cancel
      </.button>
    </div>
    """
  end
end
