defmodule Dns302.Server do
  import Plug.Conn

  @template_dir "lib/dns302/templates/"

  def init(options) do
    options
  end

  def call(%{host: host} = conn, [host: host]) do
    render_template(conn, "info.html.eex")
  end

  def call(conn, _opts) do
    case Dns302.get_redirect_url(conn.host) do
      nil -> show_debug_page(conn)
      url -> redirect(conn, url)
    end
  end

  defp redirect(conn, to) do
    conn
    |> put_resp_header("location", "#{to}")
    |> send_resp(302, "You are being redirected")
  end

  defp show_debug_page(conn) do
    render_template(conn, "debug.html.eex", host: conn.host)
  end

  defp render_template(%{status: status} = conn, template, assigns \\ []) do
    body =
      @template_dir
      |> Path.join(template)
      |> EEx.eval_file(assigns)

    send_resp(conn, status || 200, body)
  end
end
