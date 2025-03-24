# frozen_string_literal: true

module Debezium
  # Represents the differences between two hashes, categorizing them as additions, removals, or modifications.
  class Change
    # @return [Object, nil] The `after` state of the record.
    attr_reader :after

    # @return [Object, nil] The `before` state of the record.
    attr_reader :before

    # Initializes a Change object and computes the differences between two hashes.
    #
    # @param before [Hash] The original hash.
    # @param after [Hash] The modified hash.
    def initialize(before, after)
      @before        = before
      @after         = after
    end

    # Checks if the provided key was added.
    #
    # @param key [Object] The key to check.
    # @return [Boolean] True if the key was added, otherwise false.
    def added?(key)
      additions.include?(key)
    end

    # Checks if the provided key was removed.
    #
    # @param key [Object] The key to check.
    # @return [Boolean] True if the key was removed, otherwise false.
    def removed?(key)
      removals.include?(key)
    end

    # Checks if the provided key was modified.
    #
    # @param key [Object] The key to check.
    # @return [Boolean] True if the key was modified, otherwise false.
    def modified?(key)
      modifications.include?(key)
    end

    # Returns the list of added key-value pairs.
    #
    # @return [Hash{Symbol => Object] A hash where keys represent added attributes and values are the added value
    def additions
      @additions ||= find_additions
    end

    # Returns the list of added key-value pairs.
    #
    # @return [Hash{Symbol => Object] A hash where keys represent removed attributes and values are the previous value
    def removals
      @removals ||= find_removals
    end

    # Returns the list of modified key-value pairs.
    #
    # @return [Hash{Symbol => Array<Object>] A hash of where keys represent modified attributes
    # and values are a tuple of the previous and next value.
    def modifications
      @modifications ||= find_modifications
    end

    private

    def find_additions
      return {} if @before.nil? || @after.nil?

      @after.reject { |key| @before.key?(key) }
    end

    def find_removals
      return {} if @before.nil? || @after.nil?

      @before.reject { |key| @after.key?(key) }
    end

    def find_modifications
      return {} if @before.nil? || @after.nil?

      @before.filter_map do |key, before_value|
        after_value = @after[key]
        next if removals.key?(key) || after_value == before_value

        [key, [before_value, after_value]]
      end
      .to_h
    end
  end
end
