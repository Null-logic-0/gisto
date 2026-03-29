defmodule GistoWeb.ErrorJSONTest do
  use GistoWeb.ConnCase, async: true

  test "renders 404" do
    assert GistoWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert GistoWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
