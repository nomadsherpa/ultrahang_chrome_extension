defmodule JumpStartTest do
  use ExUnit.Case
  use JumpStart.DataCase

  test "end to end test" do
    timings = VideoProcessor.start()

    # It returns the recommended starting time for the video
    assert timings == [115.68]

    # It created a new video record in the DB
    new_video = JumpStart.Videos.list_videos() |> List.last()

    assert new_video.yt_id == "dC4f5aVKKz4"
    assert new_video.title == "New vid title"
    assert new_video.published_at == ~U[2025-01-07 10:15:02Z]
  end
end
