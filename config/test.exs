use Mix.Config

config :lighthouse,
   udp_api: Lighthouse.Test.UdpMock,
   node_lifespan: 100,
   broadcast_interval: 10

config :logger, level: :warn
