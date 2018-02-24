# Lightbulb

Lightbulb is a library for sending utp broadcasts to find other nodes in the same network.

[![Build Status](https://travis-ci.org/thomasvolk/lightbulb.svg?branch=master)](https://travis-ci.org/thomasvolk/lightbulb)
[![Coverage Status](https://coveralls.io/repos/github/thomasvolk/lightbulb/badge.svg?branch=master)](https://coveralls.io/github/thomasvolk/lightbulb?branch=master)

## Installation

The package can be installed by adding `lightbulb` to your list of dependencies in `mix.exs`:

```elixir

def application do
  [applications: [:lightbulb]]
end

def deps do
  [
    {:lightbulb, git: "https://github.com/thomasvolk/lightbulb.git", tag: "master"}
  ]
end
```

## Usage

Start lightbulb with iex -S mix. If you have two other servers running you see this.

```
$ iex -S mix
[info]  start Elixir.Lightbulb.Ip4UdpServer port=9998

[info]  start Elixir.Lightbulb.Ip4UdpBroadcast port=9998

iex(1)> Lightbulb.get_nodes()
[{{10, 2, 1, 210}, "lightbulb::node"},
 {{10, 2, 1, 211}, "lightbulb::node"},
 {{10, 2, 1, 212}, "lightbulb::node"}]

```
