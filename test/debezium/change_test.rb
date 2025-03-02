# frozen_string_literal: true

require 'test_helper'

class ChangeTest < Minitest::Test
  def setup
    old_hash = { a: 1, b: 2, c: 3 }
    new_hash = { b: 2, c: 4, d: 5 }

    @change = Debezium::Change.new(old_hash, new_hash)
  end

  def test_added?
    assert @change.added?(:d)
    refute @change.added?(:b)
  end

  def test_removed?
    assert @change.removed?(:a)
    refute @change.removed?(:b)
  end

  def test_modified?
    assert @change.modified?(:c)
    refute @change.modified?(:b)
  end

  def test_additions
    assert_equal [[:d, 5]], @change.additions
  end

  def test_removals
    assert_equal [[:a, 1]], @change.removals
  end

  def test_modifications
    assert_equal [[:c, [4, 3]]], @change.modifications
  end
end
