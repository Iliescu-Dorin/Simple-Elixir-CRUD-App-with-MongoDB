defmodule Dream do

  defstruct [:id, :user_id, :category, :title, :body, :events]


  def create(attrs \\ %{}) do
    %__MODULE__{ attrs | id: generate_id(), events: [] }
  end

  def update(dream = %__MODULE__{}, attrs) do
    %__MODULE__{ dream | attrs }
  end

  def add_event(dream, event) do
    %__MODULE__{ dream | events: [event | dream.events] }
  end


  defp generate_id() do
    UUID.uuid4()
  end
end