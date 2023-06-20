defmodule BackendStuffApi.Router do
  import BackendStuffApi.Helpers.MapHelper
  use Plug.Router
  plug(Plug.Logger)

  plug :match

  plug(Plug.Parsers,
    parsers: [:json, :urlencoded, :multipart],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug :dispatch

  get("/", do: send_resp(conn, 200, "OK"))

  get("/aliens_name", do: send_resp(conn, 200, "Blork Erlang"))

  get "/knockknock" do
    # Starts an unpooled connection
    case Mongo.start_link(url: "mongodb://localhost:27017/backend_stuff_api_db") do
      {:ok, _} -> send_resp(conn, 200, "Who's there?")
      {:error, _} -> send_resp(conn, 500, "Something went wrong")
    end
  end

  post "/register" do
    case conn.body_params do
      %{"email" => email, "password" => password} ->
        case Mongo.insert_one(:mongo, "users", %{"email" => email, "password" => password}) do
          {:ok, user} ->
            doc = Mongo.find_one(:mongo, "users", %{_id: user.inserted_id})

            user =
              BackendStuffApi.JSONUtils.normaliseMongoId(doc)
              |> Jason.encode!()

            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, user)

          {:error, _} ->
            send_resp(conn, 500, "Something went wrong")
        end

      _ ->
        send_resp(conn, 400, '')
    end
  end

  post "/login" do
    case Plug.Conn.read_body(conn) do
      {:ok, _body, conn} ->
        email = conn.params["email"]
        password = conn.params["password"]
        case Mongo.find_one(:mongo, "users", %{email: email}) do
          nil ->
            send_resp(conn, 401, "Invalid email or password")

          user ->
            if Comeonin.Bcrypt.checkpw(password, user["password"]) do
              token = DreamApp.Auth.encode_token(user["_id"])
              send_resp(conn, 200, %{token: token})
            else
              send_resp(conn, 401, "Invalid email or password!")
            end
        end
    end
  end

  post "/dreams" do
    case conn.body_params do
      %{"title" => title, "category" => category, "body" => body} ->
        case Mongo.insert_one(:mongo, "dreams", %{"title" => title, "category" => category, "body" => body}) do
          {:ok, user} ->
            doc = Mongo.find_one(:mongo, "dreams", %{_id: user.inserted_id})

            dream =
              BackendStuffApi.JSONUtils.normaliseMongoId(doc)
              |> Jason.encode!()

            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, dream)

          {:error, _} ->
            send_resp(conn, 500, "Something went wrong")
        end

      _ ->
        send_resp(conn, 400, '')
    end
  end

  get "/dreams" do
    dreams =
      Mongo.find(:mongo, "dreams", %{})
      |> Enum.map(&BackendStuffApi.JSONUtils.normaliseMongoId/1)
      |> Enum.to_list()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, dreams)
  end

  get "/dreams/:id" do
    doc = Mongo.find_one(:mongo, "dreams", %{_id: BSON.ObjectId.decode!(id)})

    case doc do
      nil ->
        send_resp(conn, 404, "Not Found")

      %{} ->
        dream =
          BackendStuffApi.JSONUtils.normaliseMongoId(doc)
          |> Jason.encode!()

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, dream)

      {:error, _} ->
        send_resp(conn, 500, "Something went wrong")
    end
  end

  put "dreams/:id" do
    case Mongo.find_one_and_update(
           :mongo,
           "dreams",
           %{_id: BSON.ObjectId.decode!(id)},
           %{
             "$set":
               conn.body_params
               |> Map.take(["name", "content"])
               |> Enum.into(%{}, fn {key, value} -> {"#{key}", value} end)
           },
           return_document: :after
         ) do
      {:ok, doc} ->
        case doc do
          nil ->
            send_resp(conn, 404, "Not Found")

          _ ->
            dream =
              BackendStuffApi.JSONUtils.normaliseMongoId(doc)
              |> Jason.encode!()

            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, dream)
        end

      {:error, _} ->
        send_resp(conn, 500, "Something went wrong")
    end
  end

  delete "dreams/:id" do
    Mongo.delete_one!(:mongo, "dreams", %{_id: BSON.ObjectId.decode!(id)})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{id: id}))
  end

  match(_, do: send_resp(conn, 404, "Not Found"))

end
