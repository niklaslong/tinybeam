defmodule TinybeamTest do
  use ExUnit.Case
  doctest Tinybeam

  test "greets the world" do
    assert Tinybeam.hello() == :world
  end
end
