defmodule Chatapp.UserStore do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_user(user_id) do
    Agent.update(__MODULE__, fn users -> [user_id | users] end)
  end

  def get_users do
    Agent.get(__MODULE__, fn users -> users end)
  end
end
