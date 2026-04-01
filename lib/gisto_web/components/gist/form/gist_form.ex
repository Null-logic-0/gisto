defmodule GistoWeb.Gist.Form.GistForm do
  use GistoWeb, :html

  import GistoWeb.Gist.Form.EditorCard
  import GistoWeb.Gist.Form.DescriptionInput
  import GistoWeb.Gist.Form.VisibilityInfo
  import GistoWeb.Gist.Form.FormActions

  def gist_form(assigns) do
    ~H"""
    <.form for={@form} id="gists-form" phx-change="validate" phx-submit="save" class="space-y-5">
      <.editor_card form={@form} />

      <.description_input form={@form} />

      <.visibility_info />

      <.form_actions return_path={@return_path} />
    </.form>
    """
  end
end
