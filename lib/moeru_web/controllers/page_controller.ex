defmodule MoeruWeb.PageController do
  use MoeruWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
