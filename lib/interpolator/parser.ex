defmodule Interpolator.Parser do
  @moduledoc """
  парсинг аргументов в специальную структуру для передачи процессору
  """

  alias Interpolator.Parser

  defstruct [:algo, :step, :number]

  def parse_args(list = [_ | _]) do
    list
    |> parse_do(%Parser{})
  end

  def parse_args(line) when is_bitstring(line) do
    String.split(line, [" ", ",", ";"])
    |> parse_do(%Parser{})
  end

  defp parse_do([], %Parser{} = args), do: args

  defp parse_do(["--algo" | [val | rest]], %Parser{} = args) do
    new_args = args

    new_args =
      cond do
        val == Interpolator.LinearInterpolator.algo_name() ->
          %Parser{args | algo: Interpolator.LinearInterpolator}

        val == Interpolator.NewtonInterpolator.algo_name() ->
          %Parser{args | algo: Interpolator.NewtonInterpolator}

        Enum.any?(combo_algos(), fn x -> x == val end) ->
          %Parser{args | algo: Interpolator.NewtonInterpolator}

        true ->
          raise ArgumentError, message: "invalid algo"
      end

    parse_do(rest, new_args)
  end

  defp parse_do(["--step" | [val | rest]], %Parser{} = args) do
    case Float.parse(val) do
      {float, _} when float > 0 -> parse_do(rest, %Parser{args | step: float})
      _ -> raise ArgumentError, message: "invalid step: step must be a positive float"
    end
  end

  defp parse_do(["--n" | [val | rest]], %Parser{} = args) do
    case Integer.parse(val) do
      {int, _} when int >= 1 ->
        parse_do(rest, %Parser{args | number: int})

      _ ->
        raise ArgumentError, message: "invalid points number: number must be a positive integer"
    end
  end

  defp parse_do([param | _], %Parser{}) do
    raise ArgumentError, message: "unknown argument: " <> param
  end

  defp combo_algos do
    ["newlin", "new-lin", "linnew", "lin-new", "newton-linear", "linear-newton"]
  end
end
