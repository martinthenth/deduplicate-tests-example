defmodule DeduplicateWeb.UserView do
  use DeduplicateWeb, :view

  alias DeduplicateWeb.UserView

  def render("show.json", %{user: user}) do
    %{
      data: %{
        user: render_one(user, UserView, "user.json")
      }
    }
  end

  def render("user.json", %{user: user}) do
    %{
      user_id: user.user_id,
      name: user.name
    }
  end
end
