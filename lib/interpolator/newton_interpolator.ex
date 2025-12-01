defmodule Interpolator.NewtonInterpolator do
  def algo_name do
    "newton"
  end

  def test do
    IO.puts("newton module")
  end

  def build(points) do
    xs = Enum.map(points, &elem(&1, 0))
    ys = Enum.map(points, &elem(&1, 1))

    coeffs = divided_differences(xs, ys)

    fn x ->
      Enum.reduce(Enum.with_index(coeffs), 0, fn {c, i}, acc ->
        term =
          if i == 0 do
            1
          else
            Enum.reduce(0..(i - 1), 1, fn j, acc2 ->
              acc2 * (x - Enum.at(xs, j))
            end)
          end

        acc + c * term
      end)
    end
  end

  defp divided_differences(xs, ys) do
    n = length(xs)

    table =
      Enum.map(0..(n - 1), fn i ->
        [Enum.at(ys, i)] ++ List.duplicate(0, n - 1)
      end)

    table =
      Enum.reduce(1..(n - 1), table, fn j, t ->
        Enum.reduce(0..(n - j - 1), t, fn i, acc ->
          f_i_j_minus_1 = acc |> Enum.at(i) |> Enum.at(j - 1)
          f_ip1_j_minus_1 = acc |> Enum.at(i + 1) |> Enum.at(j - 1)

          num = f_ip1_j_minus_1 - f_i_j_minus_1
          den = Enum.at(xs, i + j) - Enum.at(xs, i)
          updated = num / den

          List.update_at(acc, i, fn row ->
            List.update_at(row, j, fn _ -> updated end)
          end)
        end)
      end)

    Enum.map(0..(n - 1), fn j ->
      table |> Enum.at(0) |> Enum.at(j)
    end)
  end
end
