defmodule DreamApp.DreamRepository do

  def create_dream(attrs) do
    %DreamApp.Dream{}
    |> DreamApp.Dream.changeset(attrs)
    |> DreamApp.Repo.insert()
  end

  def delete_dream(%DreamApp.Dream{} = dream) do
    DreamApp.Repo.delete(dream)
  end

  def update_dream(%DreamApp.Dream{} = dream, attrs) do
    dream
    |> DreamApp.Dream.changeset(attrs)
    |> DreamApp.Repo.update()
  end

  def get_dream_by_id(id) do
    DreamApp.Repo.get(DreamApp.Dream, id)
  end
end