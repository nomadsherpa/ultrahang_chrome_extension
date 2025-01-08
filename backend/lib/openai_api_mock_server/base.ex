defmodule OpenaiApiMockServer.Base do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  post "/v1/chat/completions" do
    body = File.read!("lib/openai_api_mock_server/responses/recent_videos.json")
    success(conn, body)
  end

  defp success(conn, body) do
    conn
    |> Plug.Conn.send_resp(200, body)
  end
end
