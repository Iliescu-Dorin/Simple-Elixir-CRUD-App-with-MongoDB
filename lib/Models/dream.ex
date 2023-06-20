defmodule DreamApp.Dream do
  use Ecto.Schema

  schema "dreams" do
    field :title, :string
    field :category, :string
    field :body, :string
    belongs_to :user, DreamApp.User

    timestamps()
  end
end