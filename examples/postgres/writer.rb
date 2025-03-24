# frozen_string_literal: true

require 'pg'

conn = PG.connect(dbname: 'testdb', user: 'debezium', password: 'debezium', host: 'localhost', port: 5432)

puts 'Starting writer...'

conn.exec(<<-SQL)
  CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
  );
SQL

puts 'Writing messages...'

loop do
  puts 'insert'
  conn.exec_params('INSERT INTO users (name, email) VALUES ($1, $2)', ['Alice', 'alice@example.com'])
  sleep 1

  puts 'update'
  conn.exec_params('UPDATE users SET name = $1 WHERE name = $2', %w[Bob Alice])
  sleep 1

  puts 'delete'
  conn.exec_params('DELETE FROM users WHERE name = $1', ['Bob'])
  sleep 1
end
