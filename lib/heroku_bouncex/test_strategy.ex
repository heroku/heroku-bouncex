defmodule Heroku.Bouncex.TestStrategy do
  @moduledoc """
  Bouncer strategy for testing purposes
  """
  @behaviour Heroku.Bouncex.BouncexStrategy

  def authorize_url!(), do: "https://localhost/oauth/authorize"

  def get_user(code) do
    if code == "real" do
      %{email: "test@test.com"}
    else
      %{email: "baduser@baduser.com"}
    end
  end
end
