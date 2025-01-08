defmodule GoogleApiMockServer.Base do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/youtube/v3/search" do
    case conn.params do
      %{"channelId" => "UChUByu3QDGaVD6iyt0jzngw"} ->
        body = File.read!("lib/google_api_mock_server/responses/recent_videos.json")
        success(conn, body)

      _ ->
        error_404(conn)
    end
  end

  defp success(conn, body) do
    conn
    |> Plug.Conn.send_resp(200, body)
  end

  defp error_404(conn) do
    conn
    |> Plug.Conn.send_resp(404, "Not found")
  end
end
