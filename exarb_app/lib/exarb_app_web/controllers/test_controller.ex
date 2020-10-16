defmodule TestController do
  use ExarbAppWeb, :controller

  def index(conn, _params) do
    render(conn, "test/index.html")
  end
end
