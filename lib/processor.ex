defmodule Processor do
  def start(%Interpolator.Parser{} = args, dest) do
    # args.algo.test()

    interpolator = args.algo

    window = Window.new(args.number)

    spawn_link(fn -> loop(dest, interpolator, window, args.step) end)
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

          send(dest, {:stream, interpolator.algo_name(), stream})
        end

        loop(dest, interpolator, window, gen_step)

      {:end} ->
        send(dest, {:end})

      data ->
        IO.puts(:standard_error, "Processor #{inspect(self())} receive unknown message: #{data}")
        loop(dest, interpolator, window, gen_step)
    end

    :ok
  end

  defp gen_stream(f, {x1, x2}, gen_step) do
    Stream.iterate(x1, &(&1 + gen_step))
    |> Stream.map(&%Interpolator.Point{x: &1, y: f.(&1)})
    |> Stream.take_while(&(&1.x <= x2 + 1.0e-12))
  end
end
