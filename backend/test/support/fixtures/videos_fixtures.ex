defmodule JumpStart.VideosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JumpStart.Videos` context.
  """

  @doc """
  Generate a video.
  """
  def video_fixture(attrs \\ %{}) do
    {:ok, video} =
      attrs
      |> Enum.into(%{
        start_time: 42,
        published_at: ~U[2025-01-10 11:43:00Z],
        title: "some title",
        transcript: "some transcript",
        yt_id: "some yt_id"
      })
      |> JumpStart.Videos.create_video()

    video
  end
end
