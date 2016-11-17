use Mix.Config

config :heroku_bouncex, :secret_key_base, "testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest"

config :heroku_bouncex, Heroku.Bouncex.OAuthStrategy, []
config :heroku_bouncex, :strategy, Heroku.Bouncex.TestStrategy
