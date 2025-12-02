defmodule Interpolator.LinearInterpolatorTest do
  use ExUnit.Case
  alias Interpolator.{LinearInterpolator, Point}

  describe "LinearInterpolator" do
    test "linear function for simple line" do
      window = %Window{
        points: [
          %Point{x: 0.0, y: 0.0},
          %Point{x: 1.0, y: 1.0}
        ],
        size: 2
      }

      f = LinearInterpolator.build(window)

      assert_in_delta f.(0.0), 0.0, 0.001
      assert_in_delta f.(0.5), 0.5, 0.001
      assert_in_delta f.(1.0), 1.0, 0.001
    end

    test "linear function for line with offset" do
      window = %Window{
        points: [
          %Point{x: 0.0, y: 2.0},
          %Point{x: 1.0, y: 4.0}
        ],
        size: 2
      }

      f = LinearInterpolator.build(window)

      assert_in_delta f.(0.0), 2.0, 0.001
      assert_in_delta f.(0.5), 3.0, 0.001
      assert_in_delta f.(1.0), 4.0, 0.001
    end

    test "linear function for negative slope" do
      window = %Window{
        points: [
          %Point{x: 0.0, y: 10.0},
          %Point{x: 2.0, y: 0.0}
        ],
        size: 2
      }

      f = LinearInterpolator.build(window)

      assert_in_delta f.(0.0), 10.0, 0.001
      assert_in_delta f.(1.0), 5.0, 0.001
      assert_in_delta f.(2.0), 0.0, 0.001
    end

    test "between arbitrary points" do
      window = %Window{
        points: [
          %Point{x: 1.0, y: 3.0},
          %Point{x: 4.0, y: 9.0}
        ],
        size: 2
      }

      f = LinearInterpolator.build(window)

      assert_in_delta f.(1.0), 3.0, 0.001
      assert_in_delta f.(2.5), 6.0, 0.001
      assert_in_delta f.(4.0), 9.0, 0.001
    end

    test "horizontal line" do
      window = %Window{
        points: [
          %Point{x: 0.0, y: 5.0},
          %Point{x: 10.0, y: 5.0}
        ],
        size: 2
      }

      f = LinearInterpolator.build(window)

      assert_in_delta f.(0.0), 5.0, 0.001
      assert_in_delta f.(5.0), 5.0, 0.001
      assert_in_delta f.(10.0), 5.0, 0.001
    end
  end
end
