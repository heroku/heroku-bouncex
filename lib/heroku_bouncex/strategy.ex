defmodule Heroku.Bouncex.OAuthStrategy do
  @moduledoc """
  Heroku Oauth Authentication Strategy
  """
  use OAuth2.Strategy
  @behaviour Heroku.Bouncex.BouncexStrategy
  require Logger

  # Public API

  @defaults [
    strategy: __MODULE__,
    site: "https://api.heroku.com",
    authorize_url: "https://id.heroku.com/oauth/authorize",
    token_url: "https://id.heroku.com/oauth/token",
  ]

  @doc """
  Construct a client for requests to Heroku.
  Optionally include any OAuth2 options here to be merged with the defaults.
  """
  def client(opts \\ []) do
    opts = Keyword.merge(@defaults, Application.get_env(:heroku_bouncex, Heroku.Bouncex.OAuthStrategy))
    |> Keyword.merge(opts)

    OAuth2.Client.new(opts)
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
    |> put_param(:client_secret, authorized_client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
