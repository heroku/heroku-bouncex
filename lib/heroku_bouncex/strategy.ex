defmodule Heroku.Bouncex.OAuthStrategy do
  @moduledoc """
  Heroku Oauth Authentication Strategy
  """
  use OAuth2.Strategy
  @behaviour Heroku.Bouncex.BouncexStrategy

  # Public API

  defp client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: System.get_env("HEROKU_OAUTH_ID"),
      client_secret: System.get_env("HEROKU_OAUTH_SECRET"),
      redirect_uri: System.get_env("OAUTH_URL_CALLBACK"),
      site: "https://id.heroku.com"
    ])
  end

  def authorize_url!(params \\ []) do
    client
    |> put_param(:scope, "identity")
    |> OAuth2.Client.authorize_url!(params)
  end

  def authorize_url(client_to_auth, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client_to_auth, params)
  end

  def get_user(code) do
    token = OAuth2.Client.get_token!(client, code: code)
    OAuth2.Client.get!(token, "/account").body
  end

  # Strategy Callbacks

  def get_token(authorized_client, params, headers) do
    authorized_client
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
