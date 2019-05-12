defmodule BowmanWeb.StarController do
  use BowmanWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
