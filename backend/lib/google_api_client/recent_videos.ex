defmodule GoogleApiClient.RecentVideos do
  @api_key System.get_env("YOUTUBE_DATA_API_KEY")

  @config Application.compile_env(:jump_start, :google_api)
  @youtube_api_url "#{@config[:base_url]}/youtube/v3"

  @channel_id "UChUByu3QDGaVD6iyt0jzngw"

  def fetch(count \\ 15) do
    # TODO: Use publishedAfter
    url =
      "#{@youtube_api_url}/search?" <>
        URI.encode_query(%{
          "part" => "snippet",
          "channelId" => @channel_id,
          "maxResults" => count,
          "order" => "date",
          "type" => "video",
          "key" => @api_key
        })

    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, decoded} = Jason.decode(body)
        {:ok, decoded["items"]}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
