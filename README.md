# Debezium

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/tatethurston/ruby-debezium/blob/main/LICENSE)
[![CI](https://github.com/tatethurston/ruby-debezium/actions/workflows/ci.yml/badge.svg)](https://github.com/tatethurston/ruby-debezium/actions/workflows/ci.yml)
[![Codecov](https://img.shields.io/codecov/c/github/tatethurston/ruby-debezium/main.svg?style=flat-square)](https://codecov.io/gh/tatethurston/ruby-debezium)
[![YARD Docs](https://img.shields.io/badge/docs-YARD-blue.svg)](https://tatethurston.github.io/ruby-debezium/)

`ruby-debezium` provides a set of classes for parsing and interacting with Debezium event messages.

## Installation

Add the following to your Gemfile:

```ruby
gem 'debezium', '~> 0.1'
```

## Example

```ruby
# frozen_string_literal: true

require 'ruby-kafka'
require 'debezium'

kafka    = Kafka.new(seed_brokers: ['localhost:9092'])
consumer = kafka.consumer(group_id: 'my-consumer-group')
consumer.subscribe('foo.bar.baz')

consumer.each_message do |msg|
  next if msg.value.nil?

  message = Debezium::Message.new(msg.value)

  case message.op
  when :create
    puts "Created..."
  when :update
    puts "Updated..."
  when :delete
    puts "Deleted..."
  else
    puts "Unknown msg:"
    puts msg
  end
end
```

## Usage

### Message

The `Message` class represents a Debezium message and provides methods to access the before and after states of a record, along with the type of operation (e.g., create, update, delete). You can create a Message instance by passing a Debezium event message (in JSON format) to the constructor.

```ruby
json    = '"{payload": {"before": {"id": 1, "name": "John"}, "after": {"id": 1, "name": "Jane"}, "op": "u"}}'
message = Debezium::Message.new(json)

# Inspecting the operation type
message.op       # => :update
message.update?  # => true
message.create?  # => false
message.delete?  # => false

# Inspecting the changes
message.changes.before           # => {"id": 1, "name": "John"}
message.changes.after            # => {"id": 1, "name": "Jane"}
message.changes.additions        # => []
message.changes.added?(:name)    # => false
message.changes.removals         # => []
message.changes.removed?(:name)  # => false
message.changes.modifications    # => { name: ["Jane", "John"] }
message.changes.modified?(:name) # => true
```

## Contributing

PR's and issues welcomed! For more guidance check out [CONTRIBUTING.md](https://github.com/tatethurston/ruby-debezium/blob/main/CONTRIBUTING.md)

Are you interested in bringing a `ruby-debezium` like experience to another framework? [Open an issue](https://github.com/tatethurston/ruby-debezium/issues/new) and let's collaborate.

## Licensing

See the project's [MIT License](https://github.com/tatethurston/ruby-debezium/blob/main/LICENSE).
