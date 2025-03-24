# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'debezium'
  spec.version       = '0.2'
  spec.authors       = ['Tate Thurston']

  spec.summary       = 'A gem to handle CDC messages from Debezium'
  spec.homepage      = 'https://github.com/tatethurston/ruby-debezium'
  spec.license       = 'MIT'

  spec.files                             = Dir['lib/**/*.rb']
  spec.require_paths                     = ['lib']
  spec.required_ruby_version             = '>= 3.2'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
