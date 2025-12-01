defmodule Processor do
  def start(%Interpolator.Parser{} = args, dest) do
    args.algo.test()

    interpolator = args.algo

    window = Window.new(args.number)

    spawn(fn -> loop(dest, interpolator, window) end)
  end

  defp loop(dest, interpolator, window, gen_step) do
    receive do
      {:point, point} ->
        window = Window.add(window, point)

        if Window.enough?(window) do
          stream =
            window
            |> interpolator.build()
            |> gen_stream(Window.bounds(window), gen_step)

          send(dest, stream)
        end

        loop(dest, interpolator, window, gen_step)

      {:end} ->
        send(dest, {:end})

      data ->
        IO.puts(:standard_error, "Processor #{inspect(self())} receive unknown message: #{data}")
        loop(dest, interpolator, window, gen_step)
    end
  end

  defp gen_stream(f, {x1, x2}, gen_step) do
    Stream.iterate(x1, &(&1 + gen_step))
    |> Stream.map(fn x -> %Interpolator.Point{x: x, y: f.x} end)
  end
end
