defmodule Dns302 do
  @moduledoc """
  Documentation for `Dns302`.
  """

  @doc """
  Get the redirect url for this domain

  ## Examples

      iex> Dns302.get_redirect_url("bedesign.be")
      ~c"https://www.linkedin.com/in/andrewfecheyrlippens/"

      iex> Dns302.get_redirect_url("telenet.be")
      nil

  """
  def get_redirect_url(domain) do
    case DNS.resolve("dns302.#{domain}", :txt) do
      {:ok, [[url]]} -> url
      _ -> nil
    end
  end
end
