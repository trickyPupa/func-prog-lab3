defmodule Interpolator do
  alias Interpolator.Parser

  def main(["--help" | _]) do
    print_help()
  end

  def main(args) do
    args
    |> Parser.parse_args()
    |> IO.inspect()
  end

  defp print_help do
    IO.puts("""
    Использование: lab3 [опции]

    Опции:
      --help      Показать эту справку
      --algo      Алгоритм интерполяции: "newton" или "linear"
      --step      Частота дискретезации
      --n         Количество точек в окне
    """)
  end
end
