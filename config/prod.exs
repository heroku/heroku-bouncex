use Mix.Config

config :oauth2, 
  serializers: %{
    "application/vnd.heroku+json" => Poison,
    "application/json" => Poison
  }
