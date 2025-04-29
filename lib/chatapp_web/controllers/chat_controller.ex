defmodule ChatappWeb.ChatController do
  use ChatappWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
