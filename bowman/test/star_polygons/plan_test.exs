defmodule StarPolygons.PlanTest do
  use ExUnit.Case
  use PropCheck
  doctest StarPolygons.Plan
  alias StarPolygons.Plan

  property "calculate thetas for points" do
    forall n <- three_or_more() do
      thetas = Plan.get_thetas(n)

      length(thetas) == n and
        List.first(thetas) != 0 and
        check_spans_between_neighbors(thetas) and
        check_in_order(thetas)
    end
  end

  def check_in_order(thetas) do
    thetas == Enum.sort(thetas)
  end

  def check_spans_between_neighbors(thetas) do
    num_points = length(thetas)
    span = :math.pi() * 2 / num_points

    thetas
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [p1, p2] ->
      within_delta(p2 - p1, span, 0.0001)
    end)
  end

  def within_delta(v1, v2, delta) do
    abs(abs(v1) - abs(v2)) < delta
  end

  # At least 3 points.
  # `pos_integer()` starts at 1.
  def three_or_more() do
    such_that(x <- pos_integer(), when: x >= 3)
  end
end
