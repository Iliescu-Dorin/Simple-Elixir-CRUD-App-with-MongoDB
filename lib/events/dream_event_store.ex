defmodule DreamEventStore do
  use GenServer

  def init(_args) do
    {:ok, %{}}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def get_events(dream_id) do
    GenServer.call(__MODULE__, {:get_events, dream_id})
  end

  def handle_call({:get_events, dream_id}, _from, state) do
    events = Map.get(state, dream_id, [])
    {:reply, events, state}
  end

  def handle_cast({:store_event, event}, state) do
    events = Map.get(state, event.dream_id, [])
    events = [event | events]

    state = Map.put(state, event.dream_id, events)
    {:noreply, state}
  end
end