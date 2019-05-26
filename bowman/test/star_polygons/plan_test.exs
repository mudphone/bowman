defmodule StarPolygons.PlanTest do
  use ExUnit.Case
  use PropCheck
  doctest StarPolygons.Plan
  alias StarPolygons.Plan

  property "calculate thetas for points" do
    forall n <- three_or_more() do
      res = Plan.get_thetas(n)

      length(res) == n     and
      List.first(res) != 0 and
      check_every_two(res)
    end
  end

  def check_every_two(thetas) do
    num_points = length(thetas)
    span = :math.pi() * 2 / num_points
    thetas
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(&span_is_correct(&1, span))
  end

  def span_is_correct([p1, p2], span) do
    within_delta(p2 - p1, span, 0.0001)
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
