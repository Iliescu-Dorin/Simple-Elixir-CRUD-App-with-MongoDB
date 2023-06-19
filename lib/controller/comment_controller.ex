# defmodule BackendStuffApi.Controller.CommentController do
#   def create_comment(conn, %{"dream_id" => dream_id, "user_id" => user_id, "body" => body}) do
#     comment = create_comment_in_db(dream_id, user_id, body)
#     send_resp(conn, :created, comment)
#   end

#   defp create_comment_in_db(dream_id, user_id, body) do
#     comment = BackendStuffApi.Models.Comment{}
#         |> Map.put(:id, "649019007693c3c732bb06e6")
#         |> Map.put(:dream_id, dream_id)
#         |> Map.put(:user_id, user_id)
#         |> Map.put(:body, body)

#     # Insert the comment into MongoDB
#     {:ok, _} = Mongo.insert_one("your_collection_name", comment)
#     comment

#   end
# end
