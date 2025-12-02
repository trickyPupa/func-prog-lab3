defmodule Interpolator.MixedInterpolator do
  def name do
    "mixed"
  end

  def test do
    IO.puts("mixed module")
  end

  def build(%Window{} = window) do
    [Interpolator.LinearInterpolator.build(window), Interpolator.NewtonInterpolator.build(window)]
  end

  def algo_order do
    ["linear", "newton"]
  end
end
