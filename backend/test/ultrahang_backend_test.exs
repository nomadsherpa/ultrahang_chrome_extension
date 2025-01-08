defmodule UltrahangBackendTest do
  use ExUnit.Case

  test "works" do
    assert VideoProcessor.start() == :noop
  end
end
