defmodule LLM do
  def fetch_starting_time(filtered_transcript) do
    question = build_question_for_llm(filtered_transcript)

    {:ok, answer_text} = ChatGPT.ask_question(question)
    {:ok, answer} = Jason.decode(answer_text)

    answer["start"]
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
