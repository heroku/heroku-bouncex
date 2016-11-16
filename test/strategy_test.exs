defmodule StrategyTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Heroku.Bouncex.OAuthStrategy

  test "strategy calls /oauth/authorize with identity scope" do
    url = OAuthStrategy.authorize_url!
    assert url =~ "scope=identity"
  end

  test "Can get a user token based on a code" do
    server = Bypass.open
    Application.put_env(:heroku_bouncex,
                          Heroku.Bouncex.OAuthStrategy, 
                          site: "http://localhost:#{server.port}")

    Bypass.expect(server, fn conn ->
      if conn.request_path == "/oauth/token" do
        send_resp(conn, 302, ~s({"access_token":"123"}))
      else
        assert conn.request_path == "/account"
        send_resp(conn, 200, ~s({"email": "test@test.com"}))
      end
    end)

    user = OAuthStrategy.get_user("test")
    assert user["email"] == "test@test.com"
  end

end
