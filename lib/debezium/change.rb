# frozen_string_literal: true

module Debezium
  # Represents the differences between two hashes, categorizing them as additions, removals, or modifications.
  class Change
    # Initializes a Change object and computes the differences between two hashes.
    #
    # @param old [Hash] The original hash.
    # @param new [Hash] The modified hash.
    def initialize(old, new)
      @additions     = {}
      @removals      = {}
      @modifications = {}

      hash_diff(old, new)
    end

    # Checks if the provided key was added.
    #
    # @param key [Object] The key to check.
    # @return [Boolean] True if the key was added, otherwise false.
    def added?(key)
      @additions.include?(key)
    end

    # Checks if the provided key was removed.
    #
    # @param key [Object] The key to check.
    # @return [Boolean] True if the key was removed, otherwise false.
    def removed?(key)
      @removals.include?(key)
    end

    # Checks if the provided key was modified.
    #
    # @param key [Object] The key to check.
    # @return [Boolean] True if the key was modified, otherwise false.
    def modified?(key)
      @modifications.include?(key)
    end

    # Returns the list of added key-value pairs.
    #
    # @return [Array<Array>] An array of key-value pairs that were added.
    def additions
      @additions.to_a
    end

    # Returns the list of removed key-value pairs.
    #
    # @return [Array<Array>] An array of key-value pairs that were removed.
    def removals
      @removals.to_a
    end

    # Returns the list of modified key-value pairs.
    #
    # @return [Array<Array>] An array of key-value pairs showing new and old values.
    def modifications
      @modifications.to_a
    end

    private

    # Computes the differences between two hashes and categorizes them into additions, removals, and modifications.
    #
    # @param old_hash [Hash] The original hash.
    # @param new_hash [Hash] The modified hash.
    # @return [void]
    def hash_diff(old_hash, new_hash)
      hash_additions(old_hash, new_hash)
      hash_removals(old_hash, new_hash)
      hash_modifications(old_hash, new_hash)
    end

    # Computes hash additions between two hashes.
    #
    # @param old_hash [Hash] The original hash.
    # @param new_hash [Hash] The modified hash.
    # @return [void]
    def hash_additions(old_hash, new_hash)
      new_hash.each do |key, value|
        next if old_hash.key?(key)

        @additions[key] = value
      end
    end

    # Computes hash removals between two hashes.
    #
    # @param old_hash [Hash] The original hash.
    # @param new_hash [Hash] The modified hash.
    # @return [void]
    def hash_removals(old_hash, new_hash)
      old_hash.each do |key, value|
        next if new_hash.key?(key)

        @removals[key] = value
      end
    end

    # Computes hash modifications between two hashes.
    #
    # @param old_hash [Hash] The original hash.
    # @param new_hash [Hash] The modified hash.
    # @return [void]
    def hash_modifications(old_hash, new_hash)
      old_hash.each do |key, value|
        next unless new_hash.key?(key)
        next if new_hash[key] == value

        @modifications[key] = [new_hash[key], value]
      end
    end
  end
end
