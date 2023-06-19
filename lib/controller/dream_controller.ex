defmodule DreamController do
  use Plug.Router

  import Jason

  plug :match
  plug :dispatch

  get "/dreams/:id" do
    id = conn.params["id"]

    # Get from database
    case MongoDB.find_one("dreams", %{"id" => id}) do
      {:ok, dream} ->
        # Create the dream retrival event.
        event = %DreamEvent{ dream_id: id, event_type: "retrival", timestamp: DateTime.utc_now() }
        dream_event = Dream.add_event(dream, event)

        conn
        |> put_status(:ok)
        |> put_resp_content_type("application/json")
        |> send_resp(:ok, Jason.encode!(dream_event))

      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> send_resp(:internal_server_error, "Error retrieving dream!")
    end
  end

  put "/dreams/:id" do
    id = conn.params["id"]
    body = Plug.Conn.read_body(conn)
    params = Jason.decode!(body)

    # Get from database.
    case MongoDB.find_one("dreams", %{"id" => id}) do
      {:ok, dream} ->
        updated_dream = Map.merge(dream, params)

        # Create the dream update event.
        event = %DreamEvent{ dream_id: updated_dream.id, event_type: "update", timestamp: DateTime.utc_now() }
        updated_dream_event = Dream.add_event(updated_dream, event)

        # Update the dream in the database.
        MongoDB.update_one("dreams", %{"id" => id}, %{"$set" => updated_dream_event})

        conn
        |> put_status(:ok)
        |> put_resp_content_type("application/json")
        |> send_resp(:ok, Jason.encode!(updated_dream_event))

      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> send_resp(:internal_server_error, "Error updating dream!")
    end
  end

  post "/dreams" do
    dream_params = Jason.decode!(conn.body_params, keys: ~w(user_id category title body)a)
    dream = Dream.create(dream_params)

    # Create the dream creation event.
    event = %DreamEvent{ dream_id: dream.id, event_type: "creation", timestamp: DateTime.utc_now() }
    dream_event = Dream.add_event(dream, event)

    # Insert into database.
    case MongoDB.insert_one("dreams", dream_event) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> put_resp_content_type("application/json")
        |> send_resp(:ok, Jason.encode!(dream_event))

      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> send_resp(:internal_server_error, "Error creating dream!")
    end
  end

  delete "/dreams/:id" do
    id = conn.params["id"]

    # Delete from database.
    case MongoDB.delete_one("dreams", %{"id" => id}) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> send_resp(:ok, "Dream has been deleted successfully!")

      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> send_resp(:internal_server_error, "Error deleting dream!")
    end
  end
end