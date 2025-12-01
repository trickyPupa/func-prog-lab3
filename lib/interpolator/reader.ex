defmodule Interpolator.Reader do
  def start(processor) do
    spawn(fn -> loop(processor) end)
  end

  defp loop(dest) do
    case read() do
      %Interpolator.Point{} = p ->
        send(dest, {:point, p})
        loop(dest)

      nil ->
        loop(dest)

      :eof ->
        send(dest, {:end})
        :ok

      _ ->
        send(dest, {:end})
        :error
    end
  end

  defp read() do
    case read_line() do
      :eof ->
        # IO.puts("END")
        :eof

      {:error, msg} ->
        IO.puts("Input error: " <> msg)
        nil

      {:ok, p} ->
        p
    end
  end

  defp read_line do
    case IO.gets("point > ") do
      :eof ->
        :eof

      {:error, msg} ->
        {:error, msg}

      "EOF" ->
        :eof

      data ->
        parse_point(data)
    end
  end

  defp parse_point(line) do
    list =
      String.split(line, [" ", ",", ";"])
      |> Enum.map(Float.parse() / 1)
      |> Enum.each(fn x ->
        case x do
          {float, _} ->
            {:ok, float}

          _ ->
            {:error}
        end
      end)

    if Enum.any?(list, fn x -> elem(x, 0) == :error end) || length(list) != 2 do
      {:error, "point must consist of two valid float numbers"}
    else
      {:ok, %Interpolator.Point{x: hd(list), y: hd(tl(list))}}
    end
  end
end
