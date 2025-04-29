defmodule ChatappWeb.ChatLive do
  use ChatappWeb, :live_view

  def mount(_params, _session, socket) do
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
