defmodule BackendStuffApi.Startup do
  def ensure_indexes do
    IO.puts "Using database backend_stuff_api_db}"
    Mongo.command(:mongo, %{createIndexes: "users",
      indexes: [ %{ key: %{ "email": 1 },
                    name: "email_idx",
                    unique: true} ] })
  end
end
