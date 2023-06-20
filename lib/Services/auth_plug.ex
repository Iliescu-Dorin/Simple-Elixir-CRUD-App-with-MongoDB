defmodule DreamApp.AuthPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_token_from_header(conn) do
      nil ->
        send_unauthorized(conn)

      token ->
        conn
        |> put_private(:token, token)
        |> check_token
    end
  end


  defp check_token(conn) do
    case DreamApp.Auth.decode_token(conn.private[:token]) do
      { :ok, _ } ->
        conn

      _ ->
        send_unauthorized(conn)
    end
  end

  defp send_unauthorized(conn) do
    conn
    |> put_resp_header("www-authenticate", "Bearer")
    |> send_resp(401, "Unauthorized!")
    |> halt()
  end

  defp get_token_from_header(conn) do
    case get_req_header(conn, "authorization") do
      [token | _] ->
        token |> String.split(" ") |> List.last()

      _ ->
        nil
    end
  end
end