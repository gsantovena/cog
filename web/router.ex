defmodule Cog.Router do
  use Cog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug Cog.Plug.Event
    plug :accepts, ["json"]
  end

  scope "/", Cog do
    pipe_through :api

    resources "/v1/users", V1.UserController

    resources "/v1/groups", V1.GroupController
    get "/v1/groups/:id/users", V1.GroupMembershipController, :index
    post "/v1/groups/:id/users", V1.GroupMembershipController, :manage_group_users

    resources "/v1/roles", V1.RoleController
    post "/v1/groups/:id/roles", V1.RoleGrantController, :manage_group_roles

    resources "/v1/permissions", V1.PermissionController, except: [:update]
    get "/v1/roles/:role_id/permissions", V1.PermissionController, :index
    post "/v1/roles/:id/permissions", V1.PermissionGrantController, :manage_role_permissions

    post "/v1/token", V1.TokenController, :create

    get "/v1/rules", V1.RuleController, :show
    resources "/v1/rules", V1.RuleController, only: [:create, :delete]

    resources "/v1/bootstrap", V1.BootstrapController, only: [:index, :create]
    resources "/v1/bundles", V1.BundlesController, only: [:index, :show, :delete, :create]

    get "/v1/bundles/:id/status", V1.BundleStatusController, :show
    post "/v1/bundles/:id/status", V1.BundleStatusController, :manage_status

    resources "/v1/chat_handles", V1.ChatHandleController, only: [:index, :update, :delete]
    get "/v1/users/:id/chat_handles", V1.ChatHandleController, :index
    post "/v1/users/:id/chat_handles", V1.ChatHandleController, :create

    # Relay management
    resources "/v1/relays", V1.RelayController
    resources "/v1/relay_groups", V1.RelayGroupController
    get "/v1/relay_groups/:id/relays", V1.RelayGroupMembershipController, :index
    post "/v1/relay_groups/:id/membership", V1.RelayGroupMembershipController, :manage_membership
    get "/v1/relay_groups/:id/bundles", V1.RelayGroupMembershipController, :index
    post "/v1/relay_groups/:id/assignment", V1.RelayGroupMembershipController, :manage_assignment

    # Event Hooks CRUD; for execution, see Cog.TriggerRouter
    resources "/v1/triggers", V1.TriggerController, only: [:index, :show, :create, :update, :delete]
  end

  scope "/", Cog do
    pipe_through :browser
  end
end
