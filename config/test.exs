use Mix.Config

config :light,
   udp_api: Light.Test.UdpMock,
   node_lifespan: 100,
   broadcast_interval: 10

config :logger, level: :warn
