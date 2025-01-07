defmodule UltrahangBackendTest do
  use ExUnit.Case
  doctest UltrahangBackend

  test "greets the world" do
    assert UltrahangBackend.hello() == :world
  end
end
