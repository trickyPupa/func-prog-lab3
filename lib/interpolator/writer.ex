defmodule Interpolator.Writer do
  def start(main_proc) do
    spawn_link(fn -> loop(main_proc) end)
  end

  def loop(main_proc) do
    receive do
      {:stream, stream} ->
        print_stream(stream)
        loop(main_proc)

      {:end} ->
        IO.puts("---END---")
        send(main_proc, {:end})

      data ->
        IO.puts(:standard_error, "Writer #{inspect(self())} receive unknown message: #{data}")
        loop(main_proc)
    end

    :ok
  end

  defp print_stream(stream) do
    stream
    |> Enum.each(fn x -> IO.puts("#{x.algo} > #{format(x.point.x)}, #{format(x.point.y)}") end)
  end

  defp format(x) do
    :erlang.float_to_binary(x, decimals: 4)
  end
end
