# Light

Light is a library for sending utp broadcasts to find other nodes in the same network.

[![Build Status](https://travis-ci.org/thomasvolk/light.svg?branch=master)](https://travis-ci.org/thomasvolk/light)
[![Coverage Status](https://coveralls.io/repos/github/thomasvolk/light/badge.svg?branch=master)](https://coveralls.io/github/thomasvolk/light?branch=master)

## Installation

The package can be installed by adding `light` to your list of dependencies in `mix.exs`:

```elixir

def application do
  [applications: [:light]]
end

def deps do
  [
    {:light, git: "https://github.com/thomasvolk/light.git", tag: "master"}
  ]
end
```

## Usage

Start light with iex -S mix. If you have two other servers running you see this.

```
$ iex -S mix
[info]  start Elixir.Light.Ip4UdpServer port=9998

[info]  start Elixir.Light.Ip4UdpBroadcast port=9998

iex(1)> Light.get_nodes()
[{{10, 2, 1, 210}, "light::node"},
 {{10, 2, 1, 211}, "light::node"},
 {{10, 2, 1, 212}, "light::node"}]

```
