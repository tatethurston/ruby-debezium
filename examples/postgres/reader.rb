# frozen_string_literal: true

require 'ruby-kafka'
require 'debezium'

puts 'Starting reader...'
kafka = Kafka.new(seed_brokers: ['localhost:9093'])
consumer = kafka.consumer(group_id: 'debezium-consumer-group')
consumer.subscribe('dbserver1.public.users')

puts 'Waiting for messages...'
consumer.each_message do |msg|
  next if msg.value.nil?

  message = Debezium::Message.new(msg.value)
  puts message.op
  puts message.before
  puts message.after
end
