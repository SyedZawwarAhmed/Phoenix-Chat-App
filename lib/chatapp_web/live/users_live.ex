defmodule ChatappWeb.UsersLive do
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

  def handle_event("navigate", %{"user-id" => user_id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/chat/#{user_id}")}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-b from-indigo-50 to-white py-8">
      <div class="max-w-xl mx-auto px-4">
        <h2 class="text-3xl font-bold text-indigo-700 text-center mb-8">
          Users who have joined
        </h2>
        
        <div class="space-y-3">
          <%= for user <- @users do %>
            <button 
              phx-click="navigate"
              phx-value-user-id={user}
              class="w-full flex items-center bg-white hover:bg-indigo-50 text-indigo-600 font-medium py-3 px-6 rounded-lg shadow-sm border border-indigo-100 transition-all duration-200 hover:shadow-md">
              <div class="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center mr-4">
                <span class="text-indigo-600 font-semibold">
                  <%= String.first("U") %>
                </span>
              </div>
              <span>User <%= user %></span>
            </button>
          <% end %>
        </div>

        <div class="mt-8 text-center text-sm text-indigo-400">
          <%= length(@users) %> users in chat
        </div>
      </div>
    </div>
    """
  end
end
