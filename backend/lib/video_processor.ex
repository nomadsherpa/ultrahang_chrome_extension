defmodule VideoProcessor do
  @five_minutes_in_seconds 300

  def start do
    {:ok, recent_video_ids} = RecentVideos.fetch_ids()

    processed_video_ids = processed_videos_ids()

    video_ids_to_process =
      MapSet.difference(MapSet.new(recent_video_ids), processed_video_ids)

    Enum.each(video_ids_to_process, fn video_id ->
      process_video(video_id)
    end)

    :noop
  end

  def process_video(video_id) do
    IO.puts("Processing video: #{video_id}")

    transcript = fetch_transcript(video_id)

    filtered_transcript =
      Enum.take_while(transcript, fn %{"duration" => duration, "start" => start} ->
        start + duration <= @five_minutes_in_seconds
      end)

    question = build_question_for_llm(filtered_transcript)
    {:ok, answer_text} = ChatGPT.ask_question(question)
    {:ok, answer} = Jason.decode(answer_text)

    IO.puts("----------------------#{answer["start"]}")

    {:ok, video_id}
  end

  # TODO: Investigate private functions

  def processed_videos_ids do
    # TODO: Read this from a database
    MapSet.new([
      "hSV4KobTbK0",
      # "dC4f5aVKKz4",
      "DgJuJq1_g2Q",
      "soDxRoePm2Q",
      "SGLNBpGw63g",
      "iO8G_lLoisU",
      "9Y0Zori8fgY",
      "Be5AqVUGdRg",
      "2G-odTeV42I",
      "-lkUXI1Lshg",
      "qef-DAAPqXk",
      "4sWpDg6xqIs",
      "tqJbE5Jth1k",
      "mtLXMINbRNA",
      "JowBJ97w810"
    ])
  end

  def fetch_transcript(video_id) do
    # TODO: handle when a video has no transcript
    IO.puts("Fetching transcript for video: #{video_id}")

    {output, 0} =
      System.cmd(
        "/Users/peter/projects/chrome_extensions/ultrahang/ultrahang/backend/bin/fetch_transcript",
        [video_id]
      )

    {:ok, transcript} = Jason.decode(output)

    transcript
  end

  def build_question_for_llm(transcript) do
    """
      Answer with this format:
      {
        "start": TIMESTAMP,
        "text": TEXT_FROM_TRANSCRIPT_SEGMENT
      }

      Giv me the start time when the conversation really starts after all the house keeping from this podcast in Hungarian.

      The first 5 minutes of the transcript:
      #{Jason.encode!(transcript)}
    """
  end
end
