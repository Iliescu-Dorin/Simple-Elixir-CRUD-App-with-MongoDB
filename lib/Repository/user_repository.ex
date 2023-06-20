defmodule DreamApp.UserRepository do

  def create_user(attrs \\ %{}) do
    %DreamApp.User{}
    |> DreamApp.User.changeset(Map.put(attrs, :email, attrs.email), [:email, :password])
    |> DreamApp.Repo.insert()
  end

  def get_user_by_id(id) do
    DreamApp.Repo.get_by(DreamApp.User, id: id)
  end

  # def get_user_by_email(email) do
  #   DreamApp.Repo.get_by(DreamApp.User, email: email)
  # end
  def get_user_by_email(email) do
    # mongo = Mongo.connect!

    # users = mongo
    #   |> Mongo.db("backend_stuff_api_db")
    #   |> Mongo.Db.collection("users")

    query = %{email: email}

    case Mongo.find_one(:mongo, "users", query) do
      {:ok, result} -> result
      {:error, _reason} -> nil
    end
  end


end
