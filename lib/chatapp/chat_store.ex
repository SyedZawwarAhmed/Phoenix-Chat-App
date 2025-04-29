defmodule Chatapp.ChatStore do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_message(message) do
    Agent.update(__MODULE__, fn messages -> [message | messages] end)
  end

  def get_messages do
    Agent.get(__MODULE__, fn messages -> messages end)
  end
end

