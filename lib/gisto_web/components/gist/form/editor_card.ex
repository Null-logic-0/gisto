defmodule GistoWeb.Gist.Form.EditorCard do
  use GistoWeb, :html

  import GistoWeb.Gist.Form.FileNameInput
  import GistoWeb.Gist.Form.CodeEditor

  def editor_card(assigns) do
    ~H"""
    <div class="card bg-base-100 border border-base-300 shadow-sm">
      <div class="card-body p-0">
        <.file_name_input form={@form} />
        <.code_editor form={@form} />
      </div>
    </div>
    """
  end
end
