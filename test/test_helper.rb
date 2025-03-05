# frozen_string_literal: true

require 'simplecov'
require 'simplecov-cobertura'
SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

require 'minitest/autorun'
require 'debezium'
