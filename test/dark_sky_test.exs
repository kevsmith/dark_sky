defmodule DarkSkyTest do
  use ExUnit.Case
  doctest DarkSky

  test "greets the world" do
    assert DarkSky.hello() == :world
  end
end
