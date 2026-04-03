defmodule GistoWeb.Gist.CommentForm do
  use GistoWeb, :html

  def comment_form(assigns) do
    ~H"""
    <.form for={@form} phx-submit="send_comment" phx-target={@myself}>
      <div class="relative">
        <.input
          field={@form[:comment]}
          type="textarea"
          placeholder="Write a comment..."
          class="textarea w-full"
        />

        <button class="mt-2 btn btn-square btn-info absolute bottom-4 right-3">
          <.icon name="hero-paper-airplane" class="size-5" />
        </button>
      </div>
    </.form>
    """
  end

  def edit_comment_form(assigns) do
    ~H"""
    <.form for={@edit_form} phx-submit="save_edit" phx-target={@myself}>
      <.input field={@edit_form[:comment]} type="textarea" class="textarea w-full" />
      <div class="flex gap-2 itmes-center justify-end mt-1">
        <.button class="btn  text-xs font-medium">Save</.button>
        <button
          type="button"
          phx-click="cancel_edit"
          phx-target={@myself}
          class="text-xs cursor-pointer text-gray-500 hover:underline"
        >
          Cancel
        </button>
      </div>
    </.form>
    """
  end

  def comment_actions(assigns) do
    ~H"""
    <div class="flex items-center justify-end gap-2 mt-1">
      <.button
        phx-click="edit_comment"
        phx-value-id={@comment.id}
        phx-target={@myself}
        class="btn btn-sm btn-ghost btn-square"
      >
        <.icon name="hero-pencil-square-solid" class="size-4 text-blue-500" />
      </.button>
      <.button
        phx-click="delete_comment"
        phx-value-id={@comment.id}
        phx-target={@myself}
        class="btn btn-sm btn-ghost btn-square"
      >
        <.icon name="hero-trash-solid" class="size-4 text-red-500" />
      </.button>
    </div>
    """
  end
end
