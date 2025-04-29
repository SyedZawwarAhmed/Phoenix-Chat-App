defmodule ChatappWeb.ChatLive do
  use ChatappWeb, :live_view
  require Logger

  def mount(params, _session, socket) do
    if connected?(socket) do
      :ok = Phoenix.PubSub.subscribe(Chatapp.PubSub, "chat")
    end

    messages = Chatapp.ChatStore.get_messages()

    {:ok,
     assign(socket,
       user_id: params["id"],
       messages: messages,
       message: "",
       loading: false
     )}
  end

  def handle_event("send_message", %{"message" => content}, socket) when content != "" do
    message = %{
      content: content,
      user_id: socket.assigns.user_id
    }

    Chatapp.ChatStore.add_message(message)
    Phoenix.PubSub.broadcast(Chatapp.PubSub, "chat", {:new_message, message})

    {:noreply, assign(socket, message: "", loading: false)}
  end

  def handle_event("send_message", _, socket) do
    {:noreply, socket}
  end

  def handle_event("form_update", %{"message" => message}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  def handle_info({:new_message, _message}, socket) do
    messages = Chatapp.ChatStore.get_messages()
    {:noreply, assign(socket, messages: messages)}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-gray-50">
      <div class="max-w-4xl mx-auto p-4">
        <div class="bg-white rounded-lg shadow-lg overflow-hidden">
          <!-- Header -->
          <div class="bg-indigo-600 px-6 py-4 flex items-center justify-between">
            <div class="flex items-center space-x-4">
              <.link
                navigate={~p"/"}
                class="text-white hover:text-indigo-100 font-medium flex items-center"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-5 w-5 mr-2"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10.707 3.293a1 1 0 0 1 0 1.414L6.414 9H17a1 1 0 1 1 0 2H6.414l4.293 4.293a1 1 0 0 1-1.414 1.414l-6-6a1 1 0 0 1 0-1.414l6-6a1 1 0 0 1 1.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                Back
              </.link>
            </div>
            <h1 class="text-xl font-bold text-white">Chat with User <%= @user_id %></h1>
          </div>

          <!-- Messages Container -->
          <div class="h-[600px] overflow-y-auto px-6 py-4 flex flex-col-reverse">
            <div class="space-y-4">
              <%= for message <- @messages do %>
                <div class={[
                  "max-w-[80%] rounded-lg p-3",
                  if(message.user_id == @user_id,
                    do: "ml-auto bg-indigo-500 text-white",
                    else: "bg-gray-100 text-gray-900"
                  )
                ]}>
                  <div class="text-sm font-medium mb-1">
                    User <%= message.user_id %>
                  </div>
                  <div class="break-words">
                    <%= message.content %>
                  </div>
                  <div class={[
                    "text-xs mt-1",
                    if(message.user_id == @user_id, do: "text-indigo-100", else: "text-gray-500")
                  ]}>
                    <%= Calendar.strftime(message.timestamp, "%I:%M %p") %>
                  </div>
                </div>
              <% end %>
            </div>
          </div>

          <!-- Message Input -->
          <div class="border-t border-gray-200 px-6 py-4">
            <form phx-submit="send_message" class="flex space-x-4">
              <input
                type="text"
                name="message"
                value={@message}
                placeholder="Type a message..."
                phx-keyup="form_update"
                class="flex-1 rounded-lg border border-gray-300 px-4 py-2 focus:outline-none focus:border-indigo-500"
                autocomplete="off"
              />
              <button
                type="submit"
                disabled={@message == ""}
                class={[
                  "px-6 py-2 rounded-lg font-medium",
                  if(@message == "",
                    do: "bg-gray-300 text-gray-500 cursor-not-allowed",
                    else: "bg-indigo-600 text-white hover:bg-indigo-700"
                  )
                ]}
              >
                Send
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
