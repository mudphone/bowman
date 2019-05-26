defmodule StarPolygons.Plan do
  alias __MODULE__

  @enforce_keys [:size, :points, :density, :point_locations]
  defstruct [:size, :points, :density, :point_locations]

  # Public API

  def new(size, points, density) when points > 0 and density > 0 and points > density do
    locations = get_point_locations(size, points)
    %Plan{size: size, points: points, density: density, point_locations: locations}
  end

  def new(_size, _points, _density) do
    {:error, :invalid_plan}
  end

  def point_locations(%Plan{point_locations: locations} = plan) do
    locations
  end

  def point_locations_for_svg_polygon(%Plan{} = plan) do
    plan
    |> Plan.point_locations()
    |> Enum.reduce("", fn {x, y}, acc ->
      x = Float.round(x, 1)
      y = Float.round(y, 1)
      acc <> " #{x},#{y}"
    end)
    |> String.trim()
  end

  # Internal API

  defp get_point_locations(size, points) do
    thetas = get_thetas(points)

    coords = Enum.map(thetas, &polar_to_cartesian(size, &1))
    # offset to center of size x size square canvas
    points
    # calc thetas for points in polar
    |> get_thetas()
    # calc cartesian
    |> Enum.map(&polar_to_cartesian(size / 2, &1))
    |> Enum.map(&convert_to_svg_coordinate(&1, size))
  end

  def get_thetas(n) do
    # offset so first point is at top
    offset = :math.pi() / 2
    span = :math.pi() * 2 / n

    0..(n - 1)
    |> Enum.map(&(&1 * span + offset))
  end

  def polar_to_cartesian(r, theta) do
    x = r * :math.cos(theta)
    y = r * :math.sin(theta)
    {x, y}
  end

  def convert_to_svg_coordinate({x, y}, size) do
    x = x + size / 2
    y = (y - size / 2) * -1
    {x, y}
  end
end
