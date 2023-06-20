defmodule BackendStuffApi.Router do
  import BackendStuffApi.Helpers.MapHelper
  use Plug.Router
  plug(Plug.Logger)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json, :urlencoded, :multipart],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get("/", do: send_resp(conn, 200, "OK"))

  get("/aliens_name", do: send_resp(conn, 200, "Blork Erlang"))

  get "/knockknock" do
    # Starts an unpooled connection
    case Mongo.start_link(url: "mongodb://localhost:27017/backend_stuff_api_db") do
      {:ok, _} -> send_resp(conn, 200, "Who's there?")
      {:error, _} -> send_resp(conn, 500, "Something went wrong")
    end
  end

  # post "/comments", Controller.CommentController, :create_comment

  # get "/insert" do
  #       Mongo.insert_one(nil, "users", %{first_name: "John", last_name: "Smith"})
  # end
  # get "/dreams/:id", private: @skip_token_verification do
  #   id = conn.params["id"]

  #   # Get from database
  #   case Mongo.find_one(:mongo,"dreams", %{"user_id": "1"}) do
  #     nil ->
  #       :error
  #     doc ->
  #       {:ok, doc |> MapHelper.string_keys_to_atoms |> merge_to_struct}
  #     {:ok, dream} ->
  #       # Create the dream retrival event.
  #       event = %DreamEvent{dream_id: id, event_type: "retrival", timestamp: DateTime.utc_now()}
  #       dream_event = Dream.add_event(dream, event)

  #       conn
  #       |> put_status(:ok)
  #       |> put_resp_content_type("application/json")
  #       |> send_resp(:ok, Jason.encode!(dream_event))

  #     {:error, _} ->
  #       conn
  #       |> put_status(:internal_server_error)
  #       |> send_resp(:internal_server_error, "Error retrieving dream!")
  #   end
  # end

  forward "/dreams", to: BackendStuffApi.DreamController
  forward "/auth", to: DreamApp.AuthController
  # forward "/comments", to: BackendStuffApi.CommentController

  # get "/dreams/:id", private: @skip_token_verification do
  #   case getById(String.to_integer(id)) do
  #     {:ok, id} ->
  #       IO.inspect(id)

  #       conn
  #       |> put_status(200)
  #       |> assign(:jsonapi, id)

  #     :error ->
  #       conn
  #       |> put_status(404)
  #       |> assign(:jsonapi, %{"error" => "There was an error"})
  #   end
  # end

  # def getById(id) do
  #   case Mongo.find_one(:mongo, "dreams", %{user_id: "1"}) do
  #     nil ->
  #       :error

  #     doc ->
  #       {:ok, doc |> MapHelper.string_keys_to_atoms()}
  #   end
  # end

  match(_, do: send_resp(conn, 404, "Not Found"))

end
