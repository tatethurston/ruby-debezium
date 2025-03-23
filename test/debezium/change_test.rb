# frozen_string_literal: true

require 'test_helper'

class ChangeTest < Minitest::Test
  class CreateTest < Minitest::Test
    def setup
      before = nil
      after  = { b: 2, c: 4, d: 5 }

      @change = Debezium::Change.new(before, after)
    end

    def test_added?
      %i[b c d].each do |key|
        refute @change.added?(key)
      end
    end

    def test_removed?
      %i[b c d].each do |key|
        refute @change.removed?(key)
      end
    end

    def test_modified?
      %i[b c d].each do |key|
        refute @change.modified?(key)
      end
    end

    def test_additions
      assert_empty(@change.additions)
    end

    def test_removals
      assert_empty(@change.removals)
    end

    def test_modifications
      assert_empty(@change.removals)
    end
  end

  class UpdateTest < Minitest::Test
    def setup
      before = { a: 1, b: 2, c: 3 }
      after  = { b: 2, c: 4, d: 5 }

      @change = Debezium::Change.new(before, after)
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
      assert_equal({ d: 5 }, @change.additions)
    end

    def test_removals
      assert_equal({ a: 1 }, @change.removals)
    end

    def test_modifications
      assert_equal({ c: [3, 4] }, @change.modifications)
    end
  end

  class DeleteTest < Minitest::Test
    def setup
      before = { b: 2, c: 4, d: 5 }
      after  = nil

      @change = Debezium::Change.new(before, after)
    end

    def test_added?
      %i[b c d].each do |key|
        refute @change.added?(key)
      end
    end

    def test_removed?
      %i[b c d].each do |key|
        refute @change.removed?(key)
      end
    end

    def test_modified?
      %i[b c d].each do |key|
        refute @change.modified?(key)
      end
    end

    def test_additions
      assert_empty(@change.additions)
    end

    def test_removals
      assert_empty(@change.removals)
    end

    def test_modifications
      assert_empty(@change.removals)
    end
  end
end
