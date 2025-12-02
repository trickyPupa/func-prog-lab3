defmodule StreamGenerator do
  # для нескольких методов интерполяции
  def gen_stream([f | rest], {x1, x2} = coords, %Interpolator.Parser{step: gen_step} = args) do
    [cur_algo | algos] = algos()
    map_func = get_map_func(f, cur_algo)
    take_while_func = get_take_while_func(x2)

    Stream.iterate(x1, &(&1 + gen_step))
    |> Stream.map(map_func)
    |> Stream.take_while(take_while_func)
    |> Stream.map(fn x -> [x] end)
    |> gen_stream(rest, coords, args, algos)
  end

  defp gen_stream(
         current_stream,
         [f | rest],
         {x1, x2} = coords,
         %Interpolator.Parser{step: gen_step} = args,
         [cur_algo | algos]
       ) do
    map_func = get_map_func(f, cur_algo)
    take_while_func = get_take_while_func(x2)

    Stream.iterate(x1, &(&1 + gen_step))
    |> Stream.map(map_func)
    |> Stream.take_while(take_while_func)
    |> Stream.zip_with(current_stream, fn a, b ->
      [a] ++ b
    end)
    |> gen_stream(rest, coords, args, algos)
  end

  defp gen_stream(current_stream, [], _, _, _) do
    current_stream
    |> Stream.flat_map(fn x -> x end)
  end

  # для одного метода
  def gen_stream(f, {x1, x2}, %Interpolator.Parser{step: gen_step} = args) do
    map_func = get_map_func(f, args.algo.name())
    take_while_func = get_take_while_func(x2)

    Stream.iterate(x1, &(&1 + gen_step))
    |> Stream.map(map_func)
    |> Stream.take_while(take_while_func)
  end

  defp get_map_func(f, label) do
    fn x -> %{point: %Interpolator.Point{x: x, y: f.(x)}, algo: label} end
  end

  defp get_take_while_func(bound) do
    fn x -> x.point.x <= bound + 1.0e-12 end
  end

  defp algos() do
    Enum.reverse(Interpolator.MixedInterpolator.algo_order())
  end
end
