defmodule Dns302.Server do
  import Plug.Conn
  require EEx

  @template_dir "lib/dns302/templates/"
  EEx.function_from_file(:defp, :render_info, Path.join(@template_dir, "info.html.eex"), [])
  EEx.function_from_file(:defp, :render_debug, Path.join(@template_dir, "debug.html.eex"), [:host])

  def init(options) do
    options
  end

  def call(%{host: host} = conn, [host: host]) do
    send_resp(conn, 200, render_info())
  end

  def call(conn, _opts) do
    case Dns302.get_redirect_url(conn.host) do
      nil -> send_resp(conn, 200, render_debug(conn.host))
      url -> redirect(conn, url)
    end
  end

  defp redirect(conn, to) do
    conn
    |> put_resp_header("location", "#{to}")
    |> send_resp(302, "You are being redirected")
  end
end
