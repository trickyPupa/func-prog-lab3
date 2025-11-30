defmodule Lab3Test do
  use ExUnit.Case

  use Interpolator.Parser

  test "parser ok" do
    parser =
      "--algo linear --step 4"
      |> Parser.parse_args()

    IO.inspect(parser)

    assert parser.algo == "linear"
    assert parser.step == 4
  end

  test "parser error" do
    assert_raise ArgumentError, fn ->
      "--algo lin --step 4"
      |> Parser.parse_args()
    end

    assert_raise ArgumentError, fn ->
      "--algo linear --step asd"
      |> Parser.parse_args()
    end

    assert_raise ArgumentError, fn ->
      "--step -3 --algo linear"
      |> Parser.parse_args()
    end
  end
end
