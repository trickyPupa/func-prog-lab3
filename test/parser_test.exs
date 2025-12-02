defmodule Interpolator.ParserTest do
  use ExUnit.Case
  alias Interpolator.Parser

  describe "parse_args/1" do
    test "linear algorithm" do
      args = Parser.parse_args(["--algo", "linear", "--step", "0.5"])
      assert args.algo == Interpolator.LinearInterpolator
      assert args.step == 0.5
      assert args.number == 2
    end

    test "newton algorithm" do
      args = Parser.parse_args(["--algo", "newton", "--step", "0.5", "--n", "5"])
      assert args.algo == Interpolator.NewtonInterpolator
      assert args.step == 0.5
      assert args.number == 5
    end

    test "mixed algorithm" do
      args = Parser.parse_args(["--algo", "newlin", "--step", "0.5", "--n", "3"])
      assert args.algo == Interpolator.MixedInterpolator
      assert args.step == 0.5
      assert args.number == 3
    end

    test "file path" do
      File.write!("test_file.txt", "test")
      args = Parser.parse_args(["--algo", "linear", "--step", "0.5", "test_file.txt"])
      assert args.file == "test_file.txt"
      File.rm!("test_file.txt")
    end

    test "error for invalid algorithm" do
      assert_raise ArgumentError, ~r/invalid algo/, fn ->
        Parser.parse_args(["--algo", "invalid", "--step", "0.5"])
      end
    end

    test "error for missing algo" do
      assert_raise ArgumentError, ~r/--algo and --step/, fn ->
        Parser.parse_args(["--step", "0.5"])
      end
    end

    test "error for invalid step" do
      assert_raise ArgumentError, ~r/invalid step/, fn ->
        Parser.parse_args(["--algo", "linear", "--step", "abc"])
      end
    end

    test "error for negative step" do
      assert_raise ArgumentError, ~r/invalid step/, fn ->
        Parser.parse_args(["--algo", "linear", "--step", "-0.5"])
      end
    end

    test "error for missing n with newton" do
      assert_raise ArgumentError, ~r/--number argument must be listed/, fn ->
        Parser.parse_args(["--algo", "newton", "--step", "0.5"])
      end
    end

    test "error for invalid n" do
      assert_raise ArgumentError, ~r/invalid points number/, fn ->
        Parser.parse_args(["--algo", "newton", "--step", "0.5", "--n", "abc"])
      end
    end

    test "error for negative n" do
      assert_raise ArgumentError, ~r/invalid points number/, fn ->
        Parser.parse_args(["--algo", "newton", "--step", "0.5", "--n", "-5"])
      end
    end

    test "error for non-existent file" do
      assert_raise ArgumentError, ~r/no such file/, fn ->
        Parser.parse_args(["--algo", "linear", "--step", "0.5", "nonexistent_file_xyz.txt"])
      end
    end

    test "accepts float step values" do
      args = Parser.parse_args(["--algo", "linear", "--step", "0.123"])
      assert_in_delta args.step, 0.123, 0.0001
    end
  end
end
