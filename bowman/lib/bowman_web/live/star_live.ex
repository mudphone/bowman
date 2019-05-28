defmodule BowmanWeb.StarLive do
  use Phoenix.LiveView
  alias StarPolygons.Plan
  alias BowmanWeb.StarView
  require StarPolygons.Plan

  def render(assigns) do
    StarView.render("star.html", assigns)
  end

  def mount(_session, socket) do
    width = 200
    num_points = 3
    density = 1
    {:ok, plan} = Plan.new(width, num_points, density)

    socket =
      assign_socket_from_plan(socket, plan)
      |> assign(:size, width)

    {:ok, socket}
  end

  def handle_event(
        "point_change",
        %{"num_points" => num_points} = params,
        %{assigns: %{plan: plan}} = socket
      ) do
    num_points = String.to_integer(num_points)

    density =
      case Map.get(params, "density") do
        nil -> plan.density
        d -> String.to_integer(d)
      end

    {:ok, plan} = Plan.update(plan, num_points, density)
    socket = assign_socket_from_plan(socket, plan)
    {:noreply, socket}
  end

  def handle_event("dec_vertices", _, %{assigns: %{num_points: num_points, plan: plan}} = socket) do
    {:ok, plan} = Plan.update_num_points(plan, num_points - 1)
    socket = assign_socket_from_plan(socket, plan)
    {:noreply, socket}
  end

  def handle_event("inc_vertices", _, %{assigns: %{num_points: num_points, plan: plan}} = socket) do
    {:ok, plan} = Plan.update_num_points(plan, num_points + 1)
    socket = assign_socket_from_plan(socket, plan)
    {:noreply, socket}
  end

  def handle_event("dec_density", _, %{assigns: %{density: density, plan: plan}} = socket) do
    {:ok, plan} = Plan.update_density(plan, density - 1)
    socket = assign_socket_from_plan(socket, plan)
    {:noreply, socket}
  end

  def handle_event(
        "inc_density",
        _,
        %{assigns: %{density: density, plan: plan}} = socket
      ) do
    {:ok, plan} = Plan.update_density(plan, density + 1)
    socket = assign_socket_from_plan(socket, plan)
    {:noreply, socket}
  end

  defp assign_socket_from_plan(socket, plan) do
    num_points = plan.num_points
    line_coords = Plan.line_coords_for_svg_star(plan)
    density = plan.density
    max_d = Plan.max_density(num_points)

    assign(socket,
      plan: plan,
      num_points: num_points,
      line_coords: line_coords,
      density: density,
      max_density: max_d
    )
  end
end
