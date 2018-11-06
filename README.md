# ExNdjson

[![Build Status](https://travis-ci.org/amrfaissal/ex_ndjson.svg?branch=master)](https://travis-ci.org/amrfaissal/ex_ndjson)
[![Hex.pm Version](https://img.shields.io/hexpm/v/ex_ndjson.svg?style=flat-square)](https://hex.pm/packages/ex_ndjson)
[![Hex.pm Download Total](https://img.shields.io/hexpm/dt/ex_ndjson.svg?style=flat-square)](https://hex.pm/packages/ex_ndjson)

ExNdjson is a Newline-delimited JSON library for Elixir that implements encoding and decoding to/from NDJSON as described in [NDJSON Spec](https://github.com/ndjson/ndjson-spec).

## Requirements

- Elixir 1.6 or later

## Installation

First, Add ExNdjson to you `mix.exs` dependencies:

```elixir
def deps do
  [
    {:ex_ndjson, "~> 0.3.0"}
  ]
end
```

Then, update your dependencies:

```shell
mix deps.get
```

## Usage

```elixir
ExNdjson.marshal!([%{"some" => "thing"}, %{"bar" => false, "foo" => 17, "quux" => true}])
#=> "{\"some\":\"thing\"}\n{\"quux\":true,\"foo\":17,\"bar\":false}\n"

ExNdjson.marshal_into_file!([%{id: 1}, [1, 2, 3]], "/path/to/dump.ndjson")
#=> :ok

ExNdjson.unmarshal('{"some": "thing"}\n{"quux":true, "foo":17, "bar": false}\r\n')
#=> [%{"some" => "thing"}, %{"bar" => false, "foo" => 17, "quux" => true}]

ExNdjson.unmarshal(<<123, 125, 10>>)
#=> [%{}]

ExNdjson.unmarshal_from_file!("/path/to/ndjson/file")
#=> [%{"id" => "1"}, [1, 2, 3]]
```

## Documentation

Full documentation can be found at [https://hexdocs.pm/ex_ndjson](https://hexdocs.pm/ex_ndjson).

## License

The library is available as open source under the terms of the MIT License.
