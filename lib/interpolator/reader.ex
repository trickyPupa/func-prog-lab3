defmodule Interpolator.Reader do
  def start(args, processor) do
    stream =
      if args.file do
        File.stream!(args.file, :line, encoding: :utf8)
      else
        IO.stream()
      end

    spawn_link(fn -> process(processor, stream) end)
  end

  defp process(dest, stream) do
    _ = stream
    |> Stream.map(&read_line(&1))
    |> Stream.map(&read(&1))
    |> Stream.map(fn
      %Interpolator.Point{} = p ->
        send(dest, {:point, p})
        :next

      nil ->
        :next

      :eof ->
        send(dest, {:end})
        :stop

      _ ->
        send(dest, {:end})
        :stop
    end)
    |> Enum.take_while(fn
      :stop ->
        false

      :next ->
        true
    end)

    send(dest, {:end})
  end

  defp read(x) do
    case x do
      :eof ->
        :eof

      {:error, msg} ->
        IO.puts("Input error: " <> msg)
        nil

      {:ok, p} ->
        p
    end
  end

  defp read_line(x) do
    case x do
      :eof ->
        :eof

      {:error, msg} ->
        {:error, msg}

      x when x in ["EOF\n", "eof\n", "end\n"] ->
        :eof

      data ->
        parse_point(data)
    end
  end

  defp parse_point(line) do
    list =
      String.split(line, [" ", ",", ";"])
      |> Enum.map(fn x -> Float.parse(x) end)
      |> Enum.map(fn x ->
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
      {:ok, %Interpolator.Point{x: elem(hd(list), 1), y: elem(hd(tl(list)), 1)}}
    end
  end
end
