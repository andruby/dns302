defmodule Dns302Test do
  use ExUnit.Case
  doctest Dns302

  test "greets the world" do
    assert Dns302.get_redirect_url("bedesign.be") ==
             ~c"https://www.linkedin.com/in/andrewfecheyrlippens/"
  end
end
