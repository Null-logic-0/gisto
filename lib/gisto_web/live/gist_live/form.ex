defmodule GistoWeb.GistLive.Form do
  use GistoWeb, :live_view

  alias Gisto.Gists
  alias Gisto.Gists.Gist

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    gist = Gists.get_gist!(socket.assigns.current_socpe, id)

    socket
    |> assign(:page_title, "Edit Gist")
    |> assign(:gist, gist)
    |> assign(:form, to_form(Gists.change_gist(socket.assigns.current_scope, gist)))
  end

  defp apply_action(socket, :new, _params) do
    gist = %Gist{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Gist")
    |> assign(:gist, gist)
    |> assign(:form, to_form(Gists.change_gist(socket.assigns.current_scope, gist)))
  end

  @impl true
  def handle_event("validate", %{"gist" => gist_params}, socket) do
    changeset = Gists.change_gist(socket.assigns.current_scope, socket.assigns.gist, gist_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"gist" => gist_params}, socket) do
    save_gist(socket, socket.assigns.live_action, gist_params)
  end

  defp save_gist(socket, :edit, gist_params) do
    case Gists.update_gist(socket.assigns.current_scope, socket.assigns.gist, gist_params) do
      {:ok, gist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Gist updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, gist)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_gist(socket, :new, gist_params) do
    case Gists.create_gist(socket.assigns.current_scope, gist_params) do
      {:ok, gist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Gist created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, gist)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _gist), do: ~p"/gists"
  defp return_path(_scope, "show", gist), do: ~p"/gists/#{gist}"
end
