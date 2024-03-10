defmodule Dns302.ServerTest do
  use ExUnit.Case
  use Plug.Test

  alias Dns302.Server

  @opts Server.init([])

  test "Shows the info page" do
    conn =
      :get
      |> conn("http://hasnodns.com/", "")
      |> Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "todo"
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

  test "user is redirected when current_user is not assigned" do
    # build a connection and run the plug

    # assert redirected_to(conn) == "/sign_in"
  end

  test "user passes through when current_user is assigned" do
    # build a connection, assign current_user, and run the plug

    # assert conn.status != 302
  end
end
