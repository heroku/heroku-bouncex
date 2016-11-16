defmodule Heroku.Bouncex.Redirector do
  @moduledoc """
  Module to let us use Phoenix style redirecting
  """
  import Plug.Conn

  def redirect(conn, opts) when is_list(opts) do
    url = url(opts)
    html = Plug.HTML.html_escape(url)
    body = "<html><body>You are being <a href=\"#{html}\">redirected</a>.</body></html>"

    conn
    |> put_resp_header("location", url)
    |> put_resp_content_type("text/html")
    |> send_resp(conn.status || 302, body)
    |> halt()
  end

  defp url(to: to) do
    to
  end

  defp url(external: external) do
    external
  end
end
