defmodule Opencov.Settings do
  use Opencov.Web, :model

  schema "settings" do
    field :signup_enabled, :boolean, default: false
    field :restricted_signup_domains, :string, default: ""
    field :default_project_visibility, :string

    timestamps()
  end
end
