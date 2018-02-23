use Mix.Config

config :light,
   udp_api: Light.UdpIpv6,
   broadcast_address: "ff02::1"

config :logger, level: :debug
