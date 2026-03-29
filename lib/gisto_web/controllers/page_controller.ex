defmodule GistoWeb.PageController do
  use GistoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
