# frozen_string_literal: true

module Debezium
  # Message represents a Debezium message, containing information about the `before` and `after`
  # states of a record.
  #
  # This class parses a Debezium event message (JSON) and provides methods to determine the type
  # of operation and access the changes between the `before` and `after` states in case of an update operation.
  #
  class Message
    # @return [Object] The `after` state of the record.
    attr_accessor :after

    # @return [Object] The `before` state of the record.
    attr_accessor :before

    # @return [Symbol] The operation type (`:create`, `:update`, `:delete`, or `:unknown`).
    attr_accessor :op

    # @return [Hash] The parsed JSON of the event.
    attr_accessor :json

    # Initializes a new Message instance by parsing the given Debezium JSON message.
    #
    # @param json [String] The Debezium JSON message to parse.
    # @return [Message] The newly created Message instance.
    def initialize(json)
      @json = JSON.parse(json)

      @before = @json['before']
      @after  = @json['after']
      @op     = parse_op(@json['op'])
    end

    # Checks if the operation is a "create" operation.
    #
    # @return [Boolean] `true` if the operation is a create, otherwise `false`.
    def create?
      @op == :create
    end

    # Checks if the operation is an "update" operation.
    #
    # @return [Boolean] `true` if the operation is an update, otherwise `false`.
    def update?
      @op == :update
    end

    # Checks if the operation is a "delete" operation.
    #
    # @return [Boolean] `true` if the operation is a delete, otherwise `false`.
    def delete?
      @op == :delete
    end

    # Returns the changes between the `before` and `after` states for update operations.
    #
    # @return [Change, nil] Returns a `Change` object if the operation is an update; otherwise `nil`.
    def changes
      return nil unless update?

      @changes ||= Change.new(before, after)
    end

    private

    # Parses the operation type from the given Debezium operation code.
    #
    # @param operation [String] The Debezium operation code (`'c'` for create, `'u'` for update, `'d'` for delete).
    # @return [Symbol] The operation (`:create`, `:update`, `:delete`, or `:unknown`).
    def parse_op(operation)
      case operation
      when 'c'
        :create
      when 'u'
        :update
      when 'd'
        :delete
      else
        :unknown
      end
    end
  end
end
