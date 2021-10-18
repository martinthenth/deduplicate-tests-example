defmodule DeduplicateWeb.Plugs.GuardianPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :deduplicate,
    module: DeduplicateWeb.Guardian,
    error_handler: DeduplicateWeb.Guardian.ErrorHandler

  plug Guardian.Plug.VerifyHeader, scheme: :none
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: false
end
