defmodule Dns302.ServerTest do
  use ExUnit.Case
  use Plug.Test

  alias Dns302.Server

  @opts Server.init([host: "testhost"])

  test "Shows the info page" do
    conn =
      :get
      |> conn("http://testhost/", "")
      |> Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ "example.com"
  end

  test "Shows the debug page" do
    conn =
      :get
      |> conn("http://hasnodns.com/", "")
      |> Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ "dns302.hasnodns"
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
