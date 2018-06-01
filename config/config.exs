# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :supreme_tsugu_chan, SupremeTsuguChanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Kw96pcOxW0DqOOsBWe9A+VGsx0u2lY8sRtKuD2N9o2AifzH1JReJKbyUFlL0xINk",
  render_errors: [view: SupremeTsuguChanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SupremeTsuguChan.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
