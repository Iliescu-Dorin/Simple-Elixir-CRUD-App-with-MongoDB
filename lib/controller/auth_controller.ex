defmodule DreamApp.AuthController do
  import Plug.Conn
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  post "/login" do
    {:ok, %{"email" => email, "password" => password}} = Plug.Conn.read_body(conn)

    case DreamApp.UserRepository.get_user_by_email(email) do
      nil ->
        send_resp(conn, 401, "Invalid email or password")

      user ->
        if Comeonin.Bcrypt.checkpw(password, user.password) do
          token = DreamApp.Auth.encode_token(user.id)
          send_resp(conn, 200, %{token: token})
        else
          send_resp(conn, 401, "Invalid email or password!")
        end
    end
  end

  post "/register" do
    # Inspect the conn struct
    IO.inspect(conn)

    case Plug.Conn.read_body(conn) do
      {:ok, body, conn} ->
        email = conn.params["email"]
        password = conn.params["password"]

        case Mongo.find_one(:mongo, "users", %{"email" => email}) do
          nil ->
            case DreamApp.UserRepository.create_user(%{email: email, password: password}) do
              {:ok, user} ->
                token = DreamApp.Auth.encode_token(user.id)
                send_resp(conn, 201, %{token: token})

              {:error, _} ->
                send_resp(conn, 500, "Failed to create user!")
            end

          _ ->
            send_resp(conn, 409, "User already exists!")
        end

      _ ->
        send_resp(conn, 400, "Failed to read request body")
    end
  end

  defp do_match(conn, _opts) do
    send_resp(conn, 404, "AuthController -> endpoint, Not Found!")
  end
end
