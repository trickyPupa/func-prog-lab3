defmodule Processor do
  def start(%Interpolator.Parser{} = args, dest) do
    interpolator = args.algo

    window = Window.new(args)

    spawn_link(fn -> loop(dest, interpolator, window, args) end)
  end

  defp loop(dest, interpolator, window, args) do
    receive do
      {:point, point} ->
        window = Window.add(window, point)

        if Window.enough?(window) do
          stream =
            window
            |> interpolator.build()
            |> StreamGenerator.gen_stream(Window.bounds(window), args)

          send(dest, {:stream, stream})
        end

        loop(dest, interpolator, window, args)

      {:end} ->
        send(dest, {:end})

      data ->
        IO.puts(:standard_error, "Processor #{inspect(self())} receive unknown message: #{data}")
        loop(dest, interpolator, window, args)
    end

    :ok
  end
end
