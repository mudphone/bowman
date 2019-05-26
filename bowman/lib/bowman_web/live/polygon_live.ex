defmodule BowmanWeb.PolygonLive do
  use Phoenix.LiveView
  alias StarPolygons.Plan
  alias BowmanWeb.StarView

  def render(assigns) do
    StarView.render("polygon.html", assigns)
  end

  def mount(_session, socket) do
    num_points = 6
    width = 200
    plan = Plan.new(width, num_points, 2)
    polygon_points = Plan.point_locations_for_svg_polygon(plan)

    socket =
      socket
      |> assign(:size, width)
      |> assign(:num_points, num_points)
      |> assign(:point_locations, polygon_points)

    {:ok, socket}
  end

  def handle_event(
        "point_change",
        %{"num_points" => num_points},
        %{assigns: %{size: size}} = socket
      ) do
    num_points = String.to_integer(num_points)

    polygon_points =
      Plan.new(size, num_points, 2)
      |> Plan.point_locations_for_svg_polygon()

    {:noreply,
     assign(socket,
       num_points: num_points,
       point_locations: polygon_points
     )}
  end

  def handle_event("click", _, socket) do
    {:noreply, update(socket, :num_points, &(&1 + 1))}
  end
end
