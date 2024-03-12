defmodule Dns302.ServerTest do
  use ExUnit.Case
  use Plug.Test

  alias Dns302.Server

  @opts Server.init([])

  test "Shows the info page" do
    conn =
      :get
      |> conn("http://dns302.dev/", "")
      |> Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ "info"
  end

  test "Shows the debug page" do
    conn =
      :get
      |> conn("http://hasnodns.com/", "")
      |> Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ "debug"
  end

  test "Does the redirect" do
    conn =
      :get
      |> conn("http://bedesign.be/", "")
      |> Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 302

    assert get_resp_header(conn, "location") == [
             "https://www.linkedin.com/in/andrewfecheyrlippens/"
           ]
  end
end
