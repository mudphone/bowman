defmodule StarPolygons.Plan do
  alias __MODULE__
  require Integer

  @enforce_keys [:size, :num_points, :density, :point_locations]
  defstruct [:size, :num_points, :density, :point_locations]

  @min_points 3
  @max_points 100

  # ========================================================+
  # Public API
  # ========================================================+

  defmacro max_density(num_points) do
    quote do
      div(unquote(num_points), 2)
    end
  end

  def min_points, do: @min_points

  def max_points, do: @max_points

  def new(size, num_points, density)
      when num_points >= @min_points and density > 0 and density <= max_density(num_points) do
    locations = get_point_locations(size, num_points)
    plan = %Plan{size: size, num_points: num_points, density: density, point_locations: locations}
    {:ok, plan}
  end

  def new(_size, _num_points, _density) do
    {:error, :invalid_plan}
  end

  def point_locations_for_svg_polygon(%Plan{} = plan) do
    plan.point_locations
    |> Enum.reduce("", fn {x, y}, acc ->
      acc <> " #{x},#{y}"
    end)
    |> String.trim()
  end

  def line_coords_for_svg_star(%Plan{point_locations: point_locations, density: density}) do
    __MODULE__.get_lines(point_locations, density)
  end

  # def max_density(num_points), do: div(num_points, 2)

  def update_num_points(%__MODULE__{size: size, density: density} = plan, num_points) do
    num_points = Enum.max([num_points, @min_points])
    density = constrain_density(density, num_points)
    __MODULE__.new(size, num_points, density)
  end

  def update_density(%__MODULE__{size: size, num_points: num_points} = plan, density) do
    density = constrain_density(density, num_points)
    __MODULE__.new(size, num_points, density)
  end

  def update(%__MODULE__{size: size}, num_points, density) when num_points >= @min_points do
    density = constrain_density(density, num_points)
    __MODULE__.new(size, num_points, density)
  end

  # ========================================================+
  # Internal API
  # ========================================================+

  def constrain_density(density, num_points) do
    Enum.min([max_density(num_points), Enum.max([1, density])])
  end

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
