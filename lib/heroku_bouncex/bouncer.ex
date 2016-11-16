defmodule Heroku.Bouncex.Bouncer do
  @moduledoc """
  Plug that ensures users are authenticated against Heroku OAuth 
  """
  use Plug.Router
  import Plug.Conn
  import Heroku.Bouncex.Redirector

  @strategy Application.get_env(:heroku_bouncex, :strategy)
  @auth_paths ["/auth/heroku/callback", "auth/failure", "auth/logout"]

  plug :put_secret_key_base
  plug :fetch_session

  plug :authenticate
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch

  def call(conn, opts) do
    conn |> put_private(:bouncex_opts, opts) |> super(opts)
  end

  def put_secret_key_base(conn, _) do
    put_in conn.secret_key_base, Application.get_env(:heroku_bouncex, :secret_key_base)
  end

  defp is_auth_request(conn) do
    conn.request_path in @auth_paths
  end

  def authenticate(conn, _opts) do
    current_user = get_current_user(conn)

    # Refactor this somehow
    if current_user do
      conn
      |> assign(:current_user, current_user)
    else
      if is_auth_request(conn) do
        conn
      else
        conn
        |> redirect(external: @strategy.authorize_url!)
      end
    end
  end

  defp get_current_user(conn) do
    conn |> get_session(:current_user)
  end

  get "/auth/heroku/callback" do
    user = @strategy.get_user(conn.params["code"])
    config = conn.private.bouncex_opts[:config]

    if config.allow_if_user(user) do
      conn
      |> put_session(:current_user, user)
      |> redirect(to: config.authorized_user_path(conn, user))
    else
      conn
      |> redirect(external: "https://dashboard.heroku.com")
    end
  end

  get "/auth/failure" do
    conn
    |> clear_session
    |> redirect(external: "https://dashboard.heroku.com")
  end

  get "/auth/logout" do
    conn
    |> clear_session
    |> redirect(to: "/")
  end

  match _ do
    conn
  end
end
