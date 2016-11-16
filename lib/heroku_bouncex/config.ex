defmodule Heroku.Bouncex.Config do
  @moduledoc """
  Config behavior for Bouncer config
  """
  @callback allow_if_user(map) :: boolean
  @callback authorized_user_path(Plug.Conn.t, map) :: Plug.Conn.t
end
