defmodule Dns302.Server do
  import Plug.Conn

  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    case Dns302.get_redirect_url(conn.host) do
      nil -> show_info_page(conn)
      url -> redirect(conn, url)
    end
  end

  def show_info_page(conn) do
    conn
    |> send_resp(200, "todo")
  end

  def redirect(conn, to) do
    conn
    |> put_resp_header("location", "#{to}")
    |> send_resp(302, "You are being redirected")
  end
end
