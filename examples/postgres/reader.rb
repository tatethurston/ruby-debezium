# frozen_string_literal: true

require 'ruby-kafka'
require 'debezium'

puts 'Starting reader...'

kafka    = Kafka.new(seed_brokers: ['localhost:9093'])
consumer = kafka.consumer(group_id: 'debezium-consumer-group')
                .subscribe('dbserver1.public.users')

puts 'Waiting for messages...'
consumer.each_message do |msg|
  next if msg.value.nil?

  message = Debezium::Message.new(msg.value)

  case message.op
  when :create
    puts 'Created...'
  when :update
    puts 'Updated...'
  when :delete
    puts 'Deleted...'
  else
    puts 'Unknown msg:'
    puts msg
  end
end
