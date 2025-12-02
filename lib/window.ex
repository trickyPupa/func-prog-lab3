defmodule Window do
  defstruct [:points, :size]

  def new(%Interpolator.Parser{number: size}) do
    %Window{points: [], size: size}
  end

  def add(%Window{points: buf, size: size} = window, point) do
    new_buf = (buf ++ [point]) |> Enum.take(-size)
    %Window{window | points: new_buf}
  end

  def enough?(%Window{points: buf, size: size}) do
    length(buf) == size
  end

  def bounds(%Window{points: buf}) do
    {List.first(buf).x, List.last(buf).x}
  end

  def to_list(%Window{points: buf}), do: buf
end
