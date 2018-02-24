use Mix.Config

config :lightbulb,
   udp_api: Lightbulb.UdpIpv6,
   broadcast_address: "ff02::1"

config :logger, level: :debug
