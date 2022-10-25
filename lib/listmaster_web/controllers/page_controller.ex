defmodule ListmasterWeb.PageController do
  use ListmasterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
