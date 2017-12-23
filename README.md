# Lighthouse

Lighthouse is a library for sending utp broadcasts to find other nodes in the same network.

## Installation

The package can be installed by adding `lighthouse` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lighthouse, git: "https://github.com/thomasvolk/lighthouse.git", tag: "master"}
  ]
end
```

## Usage

Start lighthouse with iex -S mix. If you have two other servers running you see this.

```
$ iex -S mix
[info]  start Elixir.Lighthouse.Ip4UdpServer port=9998

[info]  start Elixir.Lighthouse.Ip4UdpBroadcast port=9998

[info]  start Elixir.Lighthouse.Scheduler interval=5000 func=&Lighthouse.Ip4UdpBroadcast.send/0

iex(1)> Lighthouse.get_nodes()
%{{10, 2, 1, 210} => #DateTime<2017-12-16 17:18:51.898192Z>,
  {10, 2, 1, 211} => #DateTime<2017-12-16 17:18:51.898502Z>,
  {10, 2, 1, 212} => #DateTime<2017-12-16 17:18:53.461900Z>}

```
