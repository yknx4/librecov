defmodule Librecov.ErrorView do
  use Librecov.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("404.json", assigns) do
    message =
      case assigns.reason do
        %Ecto.NoResultsError{} -> "could not find model"
        _ -> "no such path"
      end

    %{error: message}
  end

  def render("500.html", _assigns) do
    "Server internal error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("500.html", assigns)
  end
end
