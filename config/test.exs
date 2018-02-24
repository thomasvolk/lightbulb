use Mix.Config

config :lightbulb,
   udp_api: Lightbulb.Test.UdpMock,
   node_lifespan: 100,
   broadcast_interval: 10

config :logger, level: :warn
