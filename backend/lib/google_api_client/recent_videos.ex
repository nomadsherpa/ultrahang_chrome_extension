defmodule GoogleApiClient.RecentVideos do
  @api_key System.get_env("YOUTUBE_DATA_API_KEY")

  @config Application.compile_env(:jump_start, :google_api)
  @youtube_api_url "#{@config[:base_url]}/youtube/v3"

  @channel_id "UChUByu3QDGaVD6iyt0jzngw"

  def fetch_ids(count \\ 15) do
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
