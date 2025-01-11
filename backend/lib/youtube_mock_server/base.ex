defmodule YoutubeMockServer.Base do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/watch" do
    body = File.read!("lib/youtube_mock_server/responses/watch.html")
    success(conn, body)
  end

  get "/api/timedtext" do
    body = File.read!("lib/youtube_mock_server/responses/timedtext.xml")
    success(conn, body)
  end

  defp success(conn, body) do
    conn
    |> Plug.Conn.send_resp(200, body)
  end
end
