defmodule Interpolator.MixedInterpolatorTest do
  use ExUnit.Case
  alias Interpolator.{MixedInterpolator, Point}

  describe "MixedInterpolator" do
    test "builds two functions" do
      window = %Window{
        points: [
          %Point{x: 0.0, y: 0.0},
          %Point{x: 1.0, y: 1.0},
          %Point{x: 2.0, y: 4.0}
        ],
        size: 3
      }

      functions = MixedInterpolator.build(window)

      assert is_list(functions)
      assert length(functions) == 2
      assert Enum.all?(functions, &is_function/1)
    end

    test "first function is linear" do
      window = %Window{
        points: [
          %Point{x: 0.0, y: 0.0},
          %Point{x: 1.0, y: 2.0},
          %Point{x: 2.0, y: 4.0}
        ],
        size: 3
      }

      [linear_f, _newton_f] = MixedInterpolator.build(window)

      assert_in_delta linear_f.(0.0), 0.0, 0.001
      assert_in_delta linear_f.(0.5), 1.0, 0.001
      assert_in_delta linear_f.(1.0), 2.0, 0.001
    end

    test "second function is newton" do
      window = %Window{
        points: [
          %Point{x: 0.0, y: 0.0},
          %Point{x: 1.0, y: 1.0},
          %Point{x: 2.0, y: 4.0}
        ],
        size: 3
      }

      [_linear_f, newton_f] = MixedInterpolator.build(window)

      assert_in_delta newton_f.(0.0), 0.0, 0.001
      assert_in_delta newton_f.(1.0), 1.0, 0.001
      assert_in_delta newton_f.(2.0), 4.0, 0.001
    end
  end
end
