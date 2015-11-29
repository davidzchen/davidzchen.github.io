---
layout: post
title: "Well-defined Configs Using Protocol Buffers"
date: 2015-09-12 15:52:24
categories: opensource
---

Google's [Protocol Buffers][proto] is a language- and platform-neutral,
high-performance serialization format. Protocol Buffers is the _lingua franca_
for data at Google, used for both RPC messages and persistent storage. One
lesser-known use case where Protocol Buffers also performs surprisingly well is
for representing configuration.

[proto]: https://developers.google.com/protocol-buffers/

## Current Config Formats

Today, some of the most widely-used configuration formats include JSON, YAML,
TOML, Java Properties (for JVM projects), and XML. Each of these formats has its
advantages but also some shortcomings.

* [**JSON**][json] is simple and easy to use, but is strictly a serialization
  format and does not provide any schema or validation capabilities without
  additional libraries, such as [JSONSchema][json-schema] or [Jackson][jackson].
* [**YAML**][yaml] extends JSON to provide improvements such as a more
  human-friendly syntax, comments, block strings, etc. However, similar to
  JSON, it is strictly a configuration format and has no notion of schema.
* [**TOML**][toml] is another attempt at a simple configuration language that
  maps to a hash table with a syntax similar to that of [Windows INI
  files][ini]. As with JSON and YAML, TOML is purely a configuration format.
* [**Java Properties**][java-properties] is extremely simple but is an
  extremely suboptimal choice for representing structured data since it has no
  built-in notion of hierarchy or type checking, and projects often end up
  implementing non-trivial logic for validation and mapping the flat key-value
  pairs to hierarchical objects.
* [**XML**][xml] is highly structured and has the advantage of using schemas.
  However, it is highly verbose, which causes both readability and writability
  to greatly suffer. The pain points of programming in XML is a major reason for
  [Gradle][gradle]'s rise in popularity compared to XML-based JVM build systems,
  such as [Maven][maven] and [Ant][ant].

Of course, there are projects that embed a language, such as [Lua][lua], or roll
their own configuration format. However, these approaches are generally more
heavyweight or involve more complexity and boilerplate than most of the above
approaches.

[json]: http://json.org
[json-schema]: http://json-schema.org
[jackson]: http://wiki.fasterxml.com/JacksonHome
[yaml]: http://yaml.org
[toml]: https://github.com/toml-lang/toml
[ini]: https://en.wikipedia.org/wiki/INI_file
[xml]: https://en.wikipedia.org/wiki/XML
[java-properties]: http://docs.oracle.com/javase/7/docs/api/java/util/Properties.html
[gradle]: http://gradle.org
[maven]: https://maven.apache.org
[ant]: http://ant.apache.org
[lua]: http://www.lua.org

## What Do Configs Need?

Configuration formats generally have a few common requirements:

* **Text format** - Since configuration is meant to be human readable and
  writable, the most important thing the configuration format needs is a text
  format. Ideally, the text format should be flexible, both easy to read and
  easy to write.
* **In-memory representation** - To use the configuration data programmatically,
  the configuration format needs a reasonable in-memory representation and API
  for parsing text configuration into the in-memory representation.
* **Structure**

## Text format

Protocol Buffers provides an easy to read [`TextFormat`][text-format], which has
a syntax simliar to JSON.

[text-format]: https://developers.google.com/protocol-buffers/docs/reference/cpp/google.protobuf.text_format?hl=en

Suppose we have the following message definition for the configuration for a
load balancer:

```proto
// Configures how the load balancer listens to incoming connections.
message FrontendConfig {
  optional uint32 port = 1 [default = 8080];
  optional string name = 2 [default = "localhost"];
}

// Configures where the load balancer sends the incoming connections.
message BackendConfig {
  enum BalanceStrategy {
    ROUND_ROBIN = 1,
    LEAST_CONN = 2,
  }
  optional BalanceStrategy balance = 1 [default = ROUND_ROBIN];

  message Server {
    required string name = 1;
    required string host = 2;
    required uint32 port = 3;
  }
  repeated Server server = 2;
}

// Configuration for the load balancer.
message ServerConfig {
  optional FrontendConfig frontend = 1;
  optional BackendConfig backend = 2;
}
```

An example configuration file in proto text format would look like the
following:

```
# Load balancer configuration
# Yes, proto text format supports comments too!

frontend {
  port: 80
  name: localhost
}

backend {
  # Load balancing strategy
  balance: ROUND_ROBIN

  # Three web servers to balance among.
  server {
    name: "web01"
    host: "127.0.0.1"
    port: 9000
  }
  server {
    name: "web02"
    host: "127.0.0.1"
    port: 9001
  }
  server {
    name: "web03"
    host: "127.0.0.1"
    port: 9002
  }
}
```

[Protocol Buffers 3][proto3] also adds an official [JSON mapping][proto3-json],
implemented via the [`JsonFormat`][json-format] API.

[proto3]: https://developers.google.com/protocol-buffers/docs/proto3
[proto3-json]: https://developers.google.com/protocol-buffers/docs/proto3#json
[json-format]: https://github.com/google/protobuf/blob/master/java/util/src/main/java/com/google/protobuf/util/JsonFormat.java

The JSON representation of above config file would look like the following:

```json
{
  "frontend": {
    "port": 80,
    "name": "localhost"
  },
  "backend": {
    "server": [
      {
        "name": "web01",
        "host": "127.0.0.1",
        "port": 9000
      },
      {
        "name": "web02",
        "host": "127.0.0.1",
        "port": 9001
      },
      {
        "name": "web03",
        "host": "127.0.0.1",
        "port": 9002
      }
    ]
  }
}
```

Even if you prefer working with JSON, the Protocol Buffers JSON mapping is an
excellent way to add well-defined schemas for your JSON data. In addition, you
also get a number of other powerful features for free, including schema
evolution, easy to use generated classes, and serialization to the Protocol
Buffers binary format.


## In-memory representation

## Structure

