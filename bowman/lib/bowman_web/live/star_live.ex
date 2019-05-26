defmodule BowmanWeb.StarLive do
  use Phoenix.LiveView
  alias StarPolygons.Plan
  alias BowmanWeb.StarView

  def render(assigns) do
    StarView.render("star.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket}
  end
end
