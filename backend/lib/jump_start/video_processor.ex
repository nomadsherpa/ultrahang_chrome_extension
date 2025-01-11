defmodule JumpStart.VideoProcessor do
  @five_minutes_in_seconds 300

  def start do
    {:ok, recent_yt_videos} = GoogleApiClient.RecentVideos.fetch()

    recent_yt_videos
    |> remove_processed
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

  defp remove_processed(recent_yt_videos) do
    recent_yt_videos_ids =
      Enum.map(recent_yt_videos, fn yt_video ->
        yt_video["id"]["videoId"]
      end)

    processed_video_ids =
      MapSet.new(JumpStart.Videos.get_processed_video_yt_ids(recent_yt_videos_ids))

    Enum.reject(recent_yt_videos, fn yt_video ->
      yt_video["id"]["videoId"] in processed_video_ids
    end)
  end

  defp process_video(video) do
    # TODO: Use a logger
    IO.puts("Processing video: #{video.yt_id}")

    transcript = fetch_transcript(video.yt_id)

    # Update the transcript in the DB
    {:ok, _} =
      JumpStart.Videos.update_video(video, %{
        transcript: transcript
      })

    start_time =
      Jason.decode!(transcript)
      |> keep_the_first_five_minutes()
      |> JumpStart.LLM.calc_starting_time()

    # Update the start time in the DB
    {:ok, _} =
      JumpStart.Videos.update_video(video, %{
        start_time: round(start_time)
      })
  end

  defp keep_the_first_five_minutes(transcript) do
    Enum.take_while(transcript, fn %{"duration" => duration, "start" => start} ->
      start + duration <= @five_minutes_in_seconds
    end)
  end

  defp fetch_transcript(video_id) do
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
