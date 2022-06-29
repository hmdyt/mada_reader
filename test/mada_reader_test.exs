defmodule MadaReaderTest do
  use ExUnit.Case
  doctest MadaReader

  test "greets the world" do
    assert MadaReader.hello() == :world
  end
end
