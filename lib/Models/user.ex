defmodule DreamApp.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :password, :string
    # field :roles, { :array, :string }, default: []

    timestamps()
  end
end
