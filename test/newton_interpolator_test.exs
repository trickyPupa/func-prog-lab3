defmodule Interpolator.NewtonInterpolatorTest do
  use ExUnit.Case
  alias Interpolator.{NewtonInterpolator, Point}

  describe "NewtonInterpolator" do
    test "linear function with 2 points" do
      window = %Window{
        points: [
          %Point{x: 0.0, y: 0.0},
          %Point{x: 1.0, y: 1.0}
        ],
        size: 2
      }

      f = NewtonInterpolator.build(window)

      assert_in_delta f.(0.0), 0.0, 0.001
      assert_in_delta f.(0.5), 0.5, 0.001
      assert_in_delta f.(1.0), 1.0, 0.001
    end

    test "quadratic function with 3 points" do
      # y = x^2
      window = %Window{
        points: [
          %Point{x: 0.0, y: 0.0},
          %Point{x: 1.0, y: 1.0},
          %Point{x: 2.0, y: 4.0}
        ],
        size: 3
      }

      f = NewtonInterpolator.build(window)

      assert_in_delta f.(0.0), 0.0, 0.001
      assert_in_delta f.(1.0), 1.0, 0.001
      assert_in_delta f.(1.5), 2.25, 0.001
      assert_in_delta f.(2.0), 4.0, 0.001
    end

    test "cubic function with 4 points" do
      # y = x^3 - 2x
      window = %Window{
        points: [
          %Point{x: 0.0, y: 0.0},
          %Point{x: 1.0, y: -1.0},
          %Point{x: 2.0, y: 4.0},
          %Point{x: 3.0, y: 21.0}
        ],
        size: 4
      }

      f = NewtonInterpolator.build(window)

      assert_in_delta f.(0.0), 0.0, 0.001
      assert_in_delta f.(1.0), -1.0, 0.001
      assert_in_delta f.(2.0), 4.0, 0.001
      assert_in_delta f.(3.0), 21.0, 0.001
    end

    test "constant function" do
      window = %Window{
        points: [
          %Point{x: 0.0, y: 5.0},
          %Point{x: 1.0, y: 5.0},
          %Point{x: 2.0, y: 5.0}
        ],
        size: 3
      }

      f = NewtonInterpolator.build(window)

      assert_in_delta f.(0.0), 5.0, 0.001
      assert_in_delta f.(1.5), 5.0, 0.001
      assert_in_delta f.(2.0), 5.0, 0.001
    end

    test "with non-uniform spacing" do
      window = %Window{
        points: [
          %Point{x: 0.0, y: 1.0},
          %Point{x: 2.0, y: 5.0},
          %Point{x: 5.0, y: 11.0}
        ],
        size: 3
      }

      f = NewtonInterpolator.build(window)

      assert_in_delta f.(0.0), 1.0, 0.001
      assert_in_delta f.(2.0), 5.0, 0.001
      assert_in_delta f.(5.0), 11.0, 0.001
    end
  end
end
