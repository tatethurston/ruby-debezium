# frozen_string_literal: true

require 'test_helper'

class MessageTest < Minitest::Test
  class CreateTest < Minitest::Test
    def setup
      @json    = '{"op": "c", "before": null, "after": {"id": 1, "name": "John Doe"}}'
      @message = Debezium::Message.new(@json)
    end

    def test_op
      assert_equal :create, @message.op
    end

    def test_before
      assert_nil @message.before
    end

    def test_after
      assert_equal({ 'id' => 1, 'name' => 'John Doe' }, @message.after)
    end

    def test_json
      assert_equal JSON.parse(@json), @message.json
    end

    def test_create?
      assert_predicate @message, :create?
    end

    def test_update?
      refute_predicate @message, :update?
    end

    def test_delete?
      refute_predicate @message, :delete?
    end

    def test_changes
      assert_nil @message.changes
    end
  end

  class UpdateTest < Minitest::Test
    def setup
      @json    = '{"op": "u", "before": {"id": 1, "name": "John Doe"}, "after": {"id": 1, "name": "Jane Doe"}}'
      @message = Debezium::Message.new(@json)
    end

    def test_op
      assert_equal :update, @message.op
    end

    def test_before
      assert_equal({ 'id' => 1, 'name' => 'John Doe' }, @message.before)
    end

    def test_after
      assert_equal({ 'id' => 1, 'name' => 'Jane Doe' }, @message.after)
    end

    def test_json
      assert_equal JSON.parse(@json), @message.json
    end

    def test_create?
      refute_predicate @message, :create?
    end

    def test_update?
      assert_predicate @message, :update?
    end

    def test_delete?
      refute_predicate @message, :delete?
    end

    def test_changes
      changes = @message.changes

      assert_instance_of Debezium::Change, changes
    end
  end

  class DeleteTest < Minitest::Test
    def setup
      @json    = '{"op": "d", "before": {"id": 1, "name": "John Doe"}, "after": null}'
      @message = Debezium::Message.new(@json)
    end

    def test_op
      assert_equal :delete, @message.op
    end

    def test_before
      assert_equal({ 'id' => 1, 'name' => 'John Doe' }, @message.before)
    end

    def test_after
      assert_nil @message.after
    end

    def test_json
      assert_equal JSON.parse(@json), @message.json
    end

    def test_create?
      refute_predicate @message, :create?
    end

    def test_update?
      refute_predicate @message, :update?
    end

    def test_delete?
      assert_predicate @message, :delete?
    end

    def test_changes
      assert_nil @message.changes
    end
  end

  class UnknownTest < Minitest::Test
    def setup
      @json    = '{"op": "x", "before": null, "after": null}'
      @message = Debezium::Message.new(@json)
    end

    def test_op
      assert_equal :unknown, @message.op
    end

    def test_before
      assert_nil @message.before
    end

    def test_after
      assert_nil @message.after
    end

    def test_json
      assert_equal JSON.parse(@json), @message.json
    end

    def test_create?
      refute_predicate @message, :create?
    end

    def test_update?
      refute_predicate @message, :update?
    end

    def test_delete?
      refute_predicate @message, :delete?
    end

    def test_changes
      assert_nil @message.changes
    end
  end
end
