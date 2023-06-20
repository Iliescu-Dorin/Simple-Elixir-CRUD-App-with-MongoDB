defmodule BackendStuffApi.DreamController do
  use Plug.Router

  plug :match
  plug :dispatch
  plug DreamApp.AuthPlug

  put "/dreams/:id" do
    { :ok, %{ "title" => title, "category" => category, "body" => body } } = Plug.Conn.read_body(conn)

    user_id = DreamApp.Auth.decode_token(conn.private[:token])["sub"]
    dream_id = conn.params["id"]

    case DreamApp.DreamRepository.get_dream_by_id(dream_id) do
      nil ->
        send_resp(conn, 404, "Dream not found!")

      %DreamApp.Dream{ user_id: user_id } = dream ->
        dream_params = %{ title: title, category: category, body: body }

        case DreamApp.DreamRepository.update_dream(dream, dream_params) do
          { :ok, dream } ->
            send_resp(conn, 200, %{ message: "Dream updated", dream: dream })

          { :error, changeset } ->
            send_resp(conn, 400, %{ errors: changeset.errors })
        end

      _ ->
        send_resp(conn, 401, "Unauthorized action!")
    end
  end

  post "/dreams" do
    { :ok, %{ "title" => title, "category" => category, "body" => body } } = Plug.Conn.read_body(conn)

    user_id = DreamApp.Auth.decode_token(conn.private[:token])["sub"]
    user = DreamApp.UserRepository.get_user_by_id(user_id)

    dream_params = %{ title: title, category: category, body: body, user: user }
    case DreamApp.DreamRepository.create_dream(dream_params) do
      { :ok, dream } ->
        send_resp(conn, 201, %{ message: "Dream created", dream: dream })

      { :error, changeset } ->
        send_resp(conn, 400, %{ errors: changeset.errors })
    end
  end

  delete "/dreams/:id" do
    user_id = DreamApp.Auth.decode_token(conn.private[:token])["sub"]
    dream_id = conn.params["id"]

    case DreamApp.DreamRepository.get_dream_by_id(dream_id) do
      nil ->
        send_resp(conn, 404, "Dream not found!")

      %DreamApp.Dream{ user_id: user_id } = dream ->
        DreamApp.DreamRepository.delete_dream(dream)
        send_resp(conn, 204, "Dream removed")

      _ ->
        send_resp(conn, 401, "Unauthorized action!")
    end
  end

  defp do_match(conn, _opts) do
    send_resp(conn, 404, "DreamController -> endpoint, Not Found!")
  end
end
