defmodule SupremeTsuguChanWeb.PageController do
  use SupremeTsuguChanWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
