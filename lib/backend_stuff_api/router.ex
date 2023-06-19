defmodule BackendStuffApi.Router do
  use Plug.Router

  plug(Plug.Logger)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get("/", do: send_resp(conn, 200, "OK"))


  plug DreamController
  get "/dreams/:id", do: DreamController.get
  put "/dreams/:id", do: DreamController.put
  post "/dreams", do: DreamController.post
  delete "/dreams/:id", do: DreamController.delete


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

  match(_, do: send_resp(conn, 404, "Not Found"))
end
