defmodule RecentVideos do
  @youtube_api_url "https://www.googleapis.com/youtube/v3"
  @api_key System.get_env("YOUTUBE_DATA_API_KEY")

  @channel_id "UChUByu3QDGaVD6iyt0jzngw"

  def fetch(count \\ 15) do
    url =
      "#{@youtube_api_url}/search?" <>
        URI.encode_query(%{
          "part" => "id",
          "channelId" => @channel_id,
          "maxResults" => count,
          "order" => "date",
          "type" => "video",
          "key" => @api_key
        })

    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, decoded} = Jason.decode(body)
        video_ids = decoded["items"] |> Enum.map(& &1["id"]["videoId"])
        {:ok, video_ids}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
