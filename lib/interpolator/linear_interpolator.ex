defmodule Interpolator.LinearInterpolator do
  alias Interpolator.Point

  def algo_name do
    "linear"
  end

  def test do
    IO.puts("linear module")
  end

  def build(%Window{
        points: [%Point{x: x0, y: y0}, %Point{x: x1, y: y1} | _]
      }) do
    k = (y1 - y0) / (x1 - x0)
    b = y0 - k * x0

    fn x -> k * x + b end
  end
end
