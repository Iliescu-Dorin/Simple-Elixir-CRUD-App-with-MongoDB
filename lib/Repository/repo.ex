defmodule DreamApp.Repo do
  def start_link do
    case MongoDB.start_link(database: "backend_stuff_api_db") do
      {:ok, pid} -> {:ok, pid}
      {:error, reason} -> {:error, reason}
    end
  end

end
