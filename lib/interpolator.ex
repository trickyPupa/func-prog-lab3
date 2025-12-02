defmodule Interpolator do
  defmodule Point do
    defstruct [:x, :y]
  end

  alias Interpolator.Parser

  def main(["--help" | _]) do
    print_help()
  end

  def main(args) do
    writer = Interpolator.Writer.start(self())

    processor =
      args
      |> Parser.parse_args()
      |> Processor.start(writer)

    Interpolator.Reader.start(processor)

    receive do
      {:end} ->
        System.halt(0)
    end

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
