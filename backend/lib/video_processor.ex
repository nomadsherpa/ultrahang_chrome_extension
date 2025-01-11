defmodule VideoProcessor do
  @five_minutes_in_seconds 300

  def start do
    {:ok, recent_yt_videos} = GoogleApiClient.RecentVideos.fetch()

    processed_video_ids = processed_video_ids()

    recent_yt_videos
    # Filter out processed videos
    |> Enum.reject(fn yt_video ->
      yt_video["id"]["videoId"] in processed_video_ids
    end)
    # Save the new videos to the DB
    |> Enum.map(fn yt_video ->
      {:ok, new_video} =
        JumpStart.Videos.create_video(%{
          yt_id: yt_video["id"]["videoId"],
          title: yt_video["snippet"]["title"],
          published_at: yt_video["snippet"]["publishedAt"]
        })

      new_video
    end)
    # Process the new videos
    |> Enum.each(&process_video/1)
  end

  def process_video(video) do
    IO.puts("Processing video: #{video.yt_id}")

    transcript = fetch_transcript(video.yt_id)

    # Update the transcript in the DB
    {:ok, _} =
      JumpStart.Videos.update_video(video, %{
        transcript: transcript
      })

    transcript_json = Jason.decode!(transcript)

    filtered_transcript =
      Enum.take_while(transcript_json, fn %{"duration" => duration, "start" => start} ->
        start + duration <= @five_minutes_in_seconds
      end)

    start_time = LLM.fetch_starting_time(filtered_transcript)

    # Update the start time in the DB
    {:ok, _} =
      JumpStart.Videos.update_video(video, %{
        start_time: round(start_time)
      })
  end

  # TODO: Investigate private functions

  def processed_video_ids do
    # TODO: Read this from a database
    MapSet.new([
      "2y8jRZZhDZ4",
      "fYhb6W9gCQU",
      "YwvSyLU3f3s",
      "VveNw8yi1H0",
      "rwnc2OSsxUM",
      "f74lXzjI-gA",
      "iHBSZYQstos",
      "hSV4KobTbK0",
      # "dC4f5aVKKz4",
      "DgJuJq1_g2Q",
      "soDxRoePm2Q",
      "SGLNBpGw63g",
      "iO8G_lLoisU",
      "9Y0Zori8fgY",
      "Be5AqVUGdRg"
    ])
  end

  def fetch_transcript(video_id) do
    # TODO: handle when a video has no transcript
    IO.puts("Fetching transcript for video: #{video_id}")

    # TODO: Fix the hardcoded path
    {transcript, 0} =
      System.cmd(
        "/Users/peter/projects/chrome_extensions/ultrahang/ultrahang/backend/bin/fetch_transcript",
        [video_id]
      )

    transcript
  end
end
