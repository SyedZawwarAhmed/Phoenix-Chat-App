defmodule ChatappWeb.ChatLive do
  use ChatappWeb, :live_view
  require Logger

  def mount(_params, _session, socket) do
    if connected?(socket) do
      random_user_id = Enum.random(1..100)
      Chatapp.UserStore.add_user(random_user_id)
      Logger.info("Adding user #{random_user_id} on WebSocket connection")
    end
    users = Chatapp.UserStore.get_users()
    {:ok, assign(socket, users: users)}
  end

  def render(assigns) do
    ~H"""
    <h2>Users in Chat</h2>
    <ul>
      <%= for user <- @users do%>
        <li><%= user %></li>
      <% end %>
    </ul>
    """
  end
end
