defmodule GistoWeb.GistLive.GistComment do
  use GistoWeb, :live_component
  alias Gisto.Comments
  alias Gisto.Comments.Comment

  def mount(socket) do
    {:ok, assign(socket, :editing_id, nil)}
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)
    gist = socket.assigns.gist
    scope = socket.assigns.current_scope

    comments = Comments.list_comments(gist)
    form = socket.assigns[:form] || Comments.change_comment(scope, %Comment{}, gist) |> to_form()

    {:ok,
     socket
     |> assign(:comments, comments)
     |> assign(:form, form)}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-6">
      <h3 class="text-lg font-semibold mb-4">Comments</h3>

      <ul class="space-y-4 mb-6">
        <%= if @comments == [] do %>
          <li class="text-gray-500 text-sm">No comments yet. Be the first!</li>
        <% else %>
          <%= for comment <- @comments do %>
            <li class="card border border-base-300 shadow-sm overflow-hidden bg-base-100 p-3">
              <div class="flex items-center justify-between mb-1">
                <span class="text-sm font-medium text-slate-400">
                  {comment.user.username}
                </span>

                <span class="text-xs  text-slate-300">
                  {Calendar.strftime(comment.inserted_at, "%b %d, %Y %H:%M")}
                </span>
              </div>

              <hr class="my-3 border-base-300" />

              <%= if @editing_id == comment.id do %>
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
              <% else %>
                <p class="text-sm ">{comment.comment}</p>
                <%= if comment.user_id == @current_scope.user.id do %>
                  <div class="flex items-center justify-end gap-2 mt-1">
                    <.button
                      phx-click="edit_comment"
                      phx-value-id={comment.id}
                      phx-target={@myself}
                      class="btn btn-sm btn-ghost btn-square"
                    >
                      <.icon name="hero-pencil-square-solid" class="size-4 text-blue-500" />
                    </.button>
                    <.button
                      phx-click="delete_comment"
                      phx-value-id={comment.id}
                      phx-target={@myself}
                      class="btn btn-sm btn-ghost btn-square"
                    >
                      <.icon name="hero-trash-solid" class="size-4 text-red-500" />
                    </.button>
                  </div>
                <% end %>
              <% end %>
            </li>
          <% end %>
        <% end %>
      </ul>

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
    </div>
    """
  end

  def handle_event("send_comment", %{"comment" => params}, socket) do
    %{current_scope: scope, gist: gist} = socket.assigns

    case Comments.create_comment(scope, gist, params) do
      {:ok, _comment} ->
        comments = Comments.list_comments(gist)
        form = Comments.change_comment(scope, %Comment{}, gist) |> to_form()

        {:noreply,
         socket
         |> assign(:comments, comments)
         |> assign(:form, form)
         |> put_flash(:info, "Comment posted!")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("edit_comment", %{"id" => id}, socket) do
    %{current_scope: scope, gist: gist} = socket.assigns
    id = String.to_integer(id)
    comment = Comments.get_comment!(scope, id)
    edit_form = Comments.change_comment(scope, comment, gist) |> to_form()

    {:noreply,
     socket
     |> assign(:editing_id, id)
     |> assign(:edit_form, edit_form)}
  end

  def handle_event("cancel_edit", _params, socket) do
    {:noreply, assign(socket, :editing_id, nil)}
  end

  def handle_event("save_edit", %{"comment" => params}, socket) do
    %{current_scope: scope, gist: gist, editing_id: id} = socket.assigns
    comment = Comments.get_comment!(scope, id)

    case Comments.update_comment(scope, gist, comment, params) do
      {:ok, _comment} ->
        comments = Comments.list_comments(gist)

        {:noreply,
         socket
         |> assign(:comments, comments)
         |> assign(:editing_id, nil)
         |> put_flash(:info, "Comment updated!")}

      {:error, changeset} ->
        {:noreply, assign(socket, :edit_form, to_form(changeset))}
    end
  end

  def handle_event("delete_comment", %{"id" => id}, socket) do
    %{current_scope: scope, gist: gist} = socket.assigns
    comment = Comments.get_comment!(scope, id)

    case Comments.delete_comment(scope, comment) do
      {:ok, _} ->
        comments = Comments.list_comments(gist)
        {:noreply, assign(socket, :comments, comments)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Could not delete comment.")}
    end
  end
end
