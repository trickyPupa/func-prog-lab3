defmodule Interpolator.ReaderTest do
  use ExUnit.Case
  alias Interpolator.{Point, Reader}

  describe "Reader" do
    test "valid point line" do
      parent = self()
      args = %Interpolator.Parser{algo: Interpolator.LinearInterpolator, step: 0.5, number: 2}

      content = "1.0 2.0\n3.0 4.0\neof\n"
      file_path = "test.txt"
      File.write!(file_path, content)

      args = %{args | file: file_path}
      Reader.start(args, parent)

      assert_receive {:point, %Point{x: 1.0, y: 2.0}}, 1000
      assert_receive {:point, %Point{x: 3.0, y: 4.0}}, 1000
      assert_receive {:end}, 1000

      File.rm!(file_path)
    end

    test "EOF" do
      parent = self()
      args = %Interpolator.Parser{algo: Interpolator.LinearInterpolator, step: 0.5, number: 2}

      content = "1.0 2.0\nEOF\n5.0 6.0\n"
      file_path = "test.txt"
      File.write!(file_path, content)

      args = %{args | file: file_path}
      Reader.start(args, parent)

      assert_receive {:point, %Point{x: 1.0, y: 2.0}}, 1000
      assert_receive {:end}, 1000

      refute_receive {:point, %Point{x: 5.0, y: 6.0}}, 500

      File.rm!(file_path)
    end

    test "different delimiters" do
      parent = self()
      args = %Interpolator.Parser{algo: Interpolator.LinearInterpolator, step: 0.5, number: 2}

      content = "1.0,2.0\n3.0;4.0\n5.0 6.0\neof\n"
      file_path = "test.txt"
      File.write!(file_path, content)

      args = %{args | file: file_path}
      Reader.start(args, parent)

      assert_receive {:point, %Point{x: 1.0, y: 2.0}}, 1000
      assert_receive {:point, %Point{x: 3.0, y: 4.0}}, 1000
      assert_receive {:point, %Point{x: 5.0, y: 6.0}}, 1000
      assert_receive {:end}, 1000

      File.rm!(file_path)
    end

    test "invalid input" do
      parent = self()
      args = %Interpolator.Parser{algo: Interpolator.LinearInterpolator, step: 0.5, number: 2}

      content = "1.0 2.0\ninvalid data\n3.0 4.0\neof\n"
      file_path = "test.txt"
      File.write!(file_path, content)

      args = %{args | file: file_path}

      ExUnit.CaptureIO.capture_io(fn ->
        Reader.start(args, parent)

        assert_receive {:point, %Point{x: 1.0, y: 2.0}}, 1000
        assert_receive {:point, %Point{x: 3.0, y: 4.0}}, 1000
        assert_receive {:end}, 1000
      end)

      File.rm!(file_path)
    end

    test "empty file" do
      parent = self()
      args = %Interpolator.Parser{algo: Interpolator.LinearInterpolator, step: 0.5, number: 2}

      content = ""
      file_path = "test.txt"
      File.write!(file_path, content)

      args = %{args | file: file_path}
      Reader.start(args, parent)

      assert_receive {:end}, 1000

      File.rm!(file_path)
    end

    test "negative numbers" do
      parent = self()
      args = %Interpolator.Parser{algo: Interpolator.LinearInterpolator, step: 0.5, number: 2}

      content = "-1.5 -2.5\n-3.0 4.0\neof\n"
      file_path = "test.txt"
      File.write!(file_path, content)

      args = %{args | file: file_path}
      Reader.start(args, parent)

      assert_receive {:point, %Point{x: -1.5, y: -2.5}}, 1000
      assert_receive {:point, %Point{x: -3.0, y: 4.0}}, 1000
      assert_receive {:end}, 1000

      File.rm!(file_path)
    end
  end
end
