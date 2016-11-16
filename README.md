# Heroku

**TODO: Add description**

To work:
Set OAUTH envs

Add plug syntax to your app

plug Heroku.Bouncex.Plug

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `heroku_bouncex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:heroku_bouncex, "~> 0.1.0"}]
    end
    ```

  2. Ensure `heroku_bouncex` is started before your application:

    ```elixir
    def application do
      [applications: [:heroku_bouncex]]
    end
    ```

