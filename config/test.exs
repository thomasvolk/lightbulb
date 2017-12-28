use Mix.Config

config :lighthouse,
   udp_api: Lighthouse.Test.UdpMock,
   node_lifespan: 100

config :logger, level: :warn
