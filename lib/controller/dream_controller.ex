# defmodule BackendStuffApi.Controller.DreamController do
#   import Plug.Conn

#   def get_dreams(conn) do
#     IO.inspect(conn)
#     # user_id = get_param(conn, "user_id")
#     dreams = get_dreams_by_user(1)
#     render(conn, dreams)
#   end

#   defp get_dreams_by_user(user_id) do
#     Mongo.find_one(:mongo, "dreams", %{"user_id" => user_id})
#   end

#   defp render(conn, dreams) do
#     conn
#     |> put_resp_content_type("application/json")
#     |> send_resp(200, dreams)
#   end
# end
