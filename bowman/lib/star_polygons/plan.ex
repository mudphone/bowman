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

  def point_locations(%Plan{point_locations: locations}) do
    locations
  end

  def point_locations_for_svg_polygon(%Plan{} = plan) do
    plan
    |> Plan.point_locations()
    |> Enum.reduce("", fn {x, y}, acc ->
      acc <> " #{x},#{y}"
    end)
    |> String.trim()
  end

  def line_coords_for_svg_star(%Plan{point_locations: point_locations, density: density}) do
    __MODULE__.get_lines(point_locations, density)
  end

  # Internal API

  def get_lines(point_locs, density) do
    num_points = length(point_locs)
    indexes = get_point_indexes(num_points, density)

    indexes
    |> Enum.map(&indexes_to_points(&1, point_locs))
  end

  def indexes_to_points([i, j], point_locs) do
    [Enum.at(point_locs, i), Enum.at(point_locs, j)]
  end

  def get_point_indexes(num_points, density) do
    offsets = 0..(density - 1)

    Enum.reduce(offsets, MapSet.new(), fn offset, acc ->
      get_point_indexes(num_points, density, offset)
      |> MapSet.union(acc)
    end)
  end

  def get_point_indexes(num_points, density, offset) do
    0..num_points
    |> Enum.map(&(density * &1 + offset))
    |> Enum.map(&Integer.mod(&1, num_points))
    |> Enum.chunk_every(2, 1, :discard)
    |> MapSet.new()
  end

  defp get_point_locations(size, points) do
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
    {Float.round(x, 1), Float.round(y, 1)}
  end
end
