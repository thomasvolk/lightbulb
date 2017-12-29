# Lighthouse

Lighthouse is a library for sending utp broadcasts to find other nodes in the same network.

[![Build Status](https://travis-ci.org/thomasvolk/lighthouse.svg?branch=master)](https://travis-ci.org/thomasvolk/lighthouse)
[![Coverage Status](https://coveralls.io/repos/github/thomasvolk/lighthouse/badge.svg?branch=master)](https://coveralls.io/github/thomasvolk/lighthouse?branch=master)

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

iex(1)> Lighthouse.get_nodes()
[{{10, 2, 1, 210}, "lighthouse::node"},
 {{10, 2, 1, 211}, "lighthouse::node"},
 {{10, 2, 1, 212}, "lighthouse::node"}]

```
