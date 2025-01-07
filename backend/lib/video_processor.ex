defmodule VideoProcessor do
  # TODO: Read this from a database
  @last_processed_video_id "dC4f5aVKKz4"
  @five_minutes_in_seconds 300

  def start do
    {:ok, recent_video_ids} = RecentVideos.fetch_ids()

    video_ids_to_process =
      Enum.take_while(recent_video_ids, fn video_id -> video_id != @last_processed_video_id end)

    Enum.each(video_ids_to_process, fn video_id ->
      process_video(video_id)
    end)

    {:ok, video_ids_to_process}
  end

  def process_video(video_id) do
    transcript = fetch_transcript(video_id)

    filtered_transcript =
      Enum.take_while(transcript, fn %{"duration" => duration, "start" => start} ->
        start + duration <= @five_minutes_in_seconds
      end)
  end

  def fetch_transcript(video_id) do
    # TODO: handle when a video has no transcript
    IO.puts("Downloading transcript for video: #{video_id}")

    {output, 0} =
      System.cmd(
        "/Users/peter/projects/chrome_extensions/ultrahang/ultrahang/backend/bin/fetch_transcript",
        [video_id]
      )

    {:ok, transcript} = Jason.decode(output)

    transcript
  end
end
