defmodule BouncerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @session Plug.Session.init(
    store: :cookie,
    key: "_app",
    encryption_salt: "yadayada",
    signing_salt: "yadayada"
  )

  alias Heroku.Bouncex.Bouncer

  defmodule TestConfig do
   @behaviour Heroku.Bouncex.Config

   def allow_if_user(user) do
     user[:email] == "test@test.com"
   end

   def authorized_user_path(_conn, _user) do
     "/"
   end
  end

  defmodule TestRouter do
    use Plug.Router

    plug Heroku.Bouncex.Bouncer, config: TestConfig

    plug :match
    plug :dispatch

    get "/private" do
      send_resp(conn, 200, "This is private")
    end

    match _ do
      send_resp(conn, 200, "I am root")
    end
  end

  @opts Bouncer.init([config: TestConfig])

  defp get_conn(path, params \\ nil) do
    conn(:get, path, params)
      |> Plug.Session.call(@session)
      |> fetch_session
  end

  test "gets redirected to Authorize URL if not authenticated" do
    conn = get_conn("/private")
      |> TestRouter.call(@opts)

    assert conn.state == :sent
    assert conn.status == 302
    location = Enum.find(conn.resp_headers, &(elem(&1, 0) == "location"))
    assert elem(location, 1) == "https://localhost/oauth/authorize"
  end

  test "assigns current user if authenticated" do
    conn = get_conn("/private")
      |> put_session(:current_user, %{email: "test@test.com"})
      |> TestRouter.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert get_session(conn, :current_user) == %{email: "test@test.com"}
    assert conn.resp_body == "This is private"
  end

  test "if user is allowed, redirect to authorized user path" do
    conn = get_conn("/auth/heroku/callback", code: "real")
      |> TestRouter.call(@opts)

    assert conn.state == :sent
    assert conn.status == 302
    assert get_session(conn, :current_user) == %{email: "test@test.com"}
    location = Enum.find(conn.resp_headers, &(elem(&1, 0) == "location"))
    assert elem(location, 1) == "/"
  end

  test "if user isn't allowed, redirect to heroku dashboard" do
    conn = get_conn("/auth/heroku/callback", code: "bad")
      |> TestRouter.call(@opts)

    assert conn.state == :sent
    assert conn.status == 302
    assert get_session(conn, :current_user) == nil
    location = Enum.find(conn.resp_headers, &(elem(&1, 0) == "location"))
    assert elem(location, 1) == "https://dashboard.heroku.com"
  end

  test "if user logs out, session is cleared" do
    conn = get_conn("/auth/logout")
      |> put_session(:current_user, %{email: "test@test.com"})
      |> TestRouter.call(@opts)

    assert get_session(conn, :current_user) == nil
  end

  test "if authentication fails, session is cleared" do
    conn = get_conn("/auth/failure")
      |> put_session(:current_user, %{email: "test@test.com"})
      |> TestRouter.call(@opts)

    assert get_session(conn, :current_user) == nil
  end
end
