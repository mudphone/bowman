defmodule BowmanWeb.StarView do
  use BowmanWeb, :view
  alias StarPolygons.Plan

  def min_points, do: Plan.min_points()

  def max_points, do: Plan.max_points()

  def enable_density_slider(max_density)
      when max_density == 1,
      do: "disabled"

  def enable_density_slider(_), do: ""

  def enable_density_dec(density, max_density)
      when density == 1 or max_density == 1,
      do: "disabled"

  def enable_density_dec(_, _), do: ""

  def enable_density_inc(density, max_density)
      when density == max_density or max_density == 1,
      do: "disabled"

  def enable_density_inc(_, _), do: ""

  def enable_points_dec(num_points) do
    case num_points > Plan.min_points() do
      true -> ""
      false -> "disabled"
    end
  end

  def enable_points_inc(num_points) do
    case num_points < Plan.max_points() do
      true -> ""
      false -> "disabled"
    end
  end
end
