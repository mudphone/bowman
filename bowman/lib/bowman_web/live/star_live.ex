defmodule BowmanWeb.StarLive do
  use Phoenix.LiveView
  alias StarPolygons.Plan
  alias BowmanWeb.StarView

  def render(assigns) do
    StarView.render("star.html", assigns)
  end

  def mount(_session, socket) do
    num_points = 6
    density = 2
    max_d = Plan.max_density(num_points)
    width = 200
    plan = Plan.new(width, num_points, density)

    socket =
      socket
      |> assign(:plan, plan)
      |> assign(:size, width)
      |> assign(:num_points, num_points)
      |> assign(:density, density)
      |> assign(:max_density, max_d)
      |> assign(:line_coords, Plan.line_coords_for_svg_star(plan))

    {:ok, socket}
  end

  def handle_event(
        "point_change",
        %{"num_points" => num_points, "density" => density},
        %{assigns: %{size: size}} = socket
      ) do
    num_points = String.to_integer(num_points)
    density = String.to_integer(density)
    max_d = Plan.max_density(num_points)

    line_coords =
      Plan.new(size, num_points, density)
      |> Plan.line_coords_for_svg_star()

    {:noreply,
     assign(socket,
       num_points: num_points,
       line_coords: line_coords,
       density: density,
       max_density: max_d
     )}
  end

  def handle_event("dec_vertices", _, %{assigns: %{num_points: num_points, plan: plan}} = socket) do
    num_points = num_points - 1
    plan = Plan.update_num_points(plan, num_points)
    socket = assign_socket_from_plan(socket, plan)
    {:noreply, socket}
  end

  def handle_event("inc_vertices", _, %{assigns: %{num_points: num_points, plan: plan}} = socket) do
    num_points = num_points + 1
    plan = Plan.update_num_points(plan, num_points)
    socket = assign_socket_from_plan(socket, plan)
    {:noreply, socket}
  end

  defp assign_socket_from_plan(socket, plan) do
    num_points = plan.num_points
    line_coords = Plan.line_coords_for_svg_star(plan)
    density = plan.density
    max_d = Plan.max_density(num_points)

    assign(socket,
      num_points: num_points,
      line_coords: line_coords,
      density: density,
      max_density: max_d
    )
  end
end
