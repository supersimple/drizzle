defmodule DrizzleTest do
  use ExUnit.Case
  doctest Drizzle

  test "greets the world" do
    assert Drizzle.hello() == :world
  end
end
