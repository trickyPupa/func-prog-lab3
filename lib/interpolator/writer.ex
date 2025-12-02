defmodule Interpolator.Writer do
  def start(main_proc) do
    spawn_link(fn -> loop(main_proc) end)
  end

  def loop(main_proc) do
    receive do
      {:stream, interpolator, stream} ->
        print_stream(stream, interpolator)
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

  defp print_stream(stream, label) do
    stream
    |> Enum.each(
      &IO.puts(
        "#{label} > #{:erlang.float_to_binary(&1.x, decimals: 2)}, #{:erlang.float_to_binary(&1.y, decimals: 2)}"
      )
    )
  end
end
