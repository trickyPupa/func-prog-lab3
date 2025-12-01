defmodule Interpolator.Writer do
  def start() do
    spawn(fn -> loop() end)
  end

  def loop() do
    receive do
      {:computed, interpolator, %Interpolator.Point{} = p} ->
        IO.puts("#{interpolator} > #{p.x}, #{p.y}")
        loop()

      {:end} ->
        IO.puts("---END---")

      data ->
        IO.puts(:standard_error, "Writer #{inspect(self())} receive unknown message: #{data}")
        loop()
    end
  end
end
