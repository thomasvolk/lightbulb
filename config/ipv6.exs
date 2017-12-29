use Mix.Config

config :lighthouse,
   udp_api: Lighthouse.UdpIpv6,
   broadcast_address: "ff02::1"

config :logger, level: :debug
