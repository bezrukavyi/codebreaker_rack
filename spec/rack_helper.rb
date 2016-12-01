$LOAD_PATH.unshift File.expand_path('../../', __FILE__)
require 'codeguessing'
require 'lib/codebreaker'
require 'support/mock_rack_app'
require 'spec_helper'
require 'rack'
Dir['app/**/*.rb'].sort.each { |f| require f }
