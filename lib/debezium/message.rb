# frozen_string_literal: true

module Debezium
  # Message represents a Debezium message, containing information about the `before` and `after`
  # states of a record.
  #
  # This class parses a Debezium event message (JSON) and provides methods to determine the type
  # of operation and access the changes between the `before` and `after` states in case of an update operation.
  #
  class Message
    # @return [Symbol] The operation type (`:create`, `:update`, `:delete`, or `:unknown`).
    attr_reader :op

    # Initializes a new Message instance by parsing the given Debezium JSON message.
    #
    # @param json [String] The Debezium JSON message to parse.
    # @return [Message] The newly created Message instance.
    def initialize(json)
      @json    = JSON.parse(json)
      @payload = @json['payload']
      @op      = parse_op
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

    # Returns the changes between the `before` and `after` states.
    #
    # @return [Change] Returns a `Change` object.
    def changes
      @changes ||= Change.new(@payload['before'], @payload['after'])
    end

    # @return [Hash] The parsed JSON of the event.
    def to_h
      @json
    end

    private

    # Parses the operation type from the given Debezium operation code.
    #
    # @return [Symbol] The operation (`:create`, `:update`, `:delete`, or `:unknown`).
    def parse_op
      case @payload['op']
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
