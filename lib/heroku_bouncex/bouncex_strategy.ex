defmodule Heroku.Bouncex.BouncexStrategy do
  @moduledoc """
  Behavior for Bouncex Strategy
  """
  @callback authorize_url!() :: binary
  @callback get_user(binary) :: map
end
