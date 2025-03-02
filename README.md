# Debezium

`ruby-debezium` provides a set of classes for parsing and interacting with Debezium event messages.

## Installation

Add the following to your Gemfile:

```ruby
gem 'debezium', '~> 0.1'
```

## Usage

### Message Class

The `Message` class represents a Debezium message and provides methods to access the before and after states of a record, along with the type of operation (e.g., create, update, delete). You can create a Message instance by passing a Debezium event message (in JSON format) to the constructor.

```ruby
json    = '{"before": {"id": 1, "name": "John"}, "after": {"id": 1, "name": "Jane"}, "op": "u"}'
message = Debezium::Message.new(json)

# Inspecting the operation type
message.op       # => :update
message.update?  # => true
message.create?  # => false
message.delete?  # => false

# Inspecting the 'before' and 'after' states
message.before # => {"id": 1, "name": "John"}
message.after  # => {"id": 1, "name": "Jane"}

# Inspecting the changes (update only)
message.changes.additions        # => []
message.changes.added?(:foo)     # => false
message.changes.removals         # => []
message.changes.removed?(:foo)   # => false
message.changes.modifications    # => [[:name, ["Jane", "John"]]]
message.changes.modified?(:name) # => true
```

## Contributing

PR's and issues welcomed! For more guidance check out [CONTRIBUTING.md](https://github.com/tatethurston/ruby-debezium/blob/main/CONTRIBUTING.md)

Are you interested in bringing a `ruby-debezium` like experience to another framework? [Open an issue](https://github.com/tatethurston/ruby-debezium/issues/new) and let's collaborate.

## Licensing

See the project's [MIT License](https://github.com/tatethurston/ruby-debezium/blob/main/LICENSE).
