defmodule Librecov.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Librecov.Web, :controller
      use Librecov.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema
      use Librecov.Core

      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def manager do
    quote do
      alias Librecov.Repo
      use Librecov.Core

      import Ecto.Changeset
    end
  end

  def service do
    quote do
      alias Librecov.Repo
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Librecov.Repo
      import Ecto.Query, only: [from: 1, from: 2]

      alias Librecov.Router.Helpers, as: Routes
      alias Librecov.Authentication
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
      import Surface
    end
  end

  def live_view do
    quote do
      use Surface.LiveView,
        layout: {Librecov.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Surface.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Surface.Component

      unquote(view_helpers())
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers
      import Librecov.LiveHelpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import Librecov.FormHelpers
      import Librecov.ErrorHelpers
      import Librecov.Gettext
      alias Librecov.Router.Helpers, as: Routes
      alias Librecov.Authentication
      alias Librecov.Views.Helper, as: ViewHelper
      alias Surface.Components.LiveRedirect
      alias Surface.Components.Link
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Librecov.Repo
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def mailer do
    quote do
      use Librecov.Mailer
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
