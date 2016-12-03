require_relative 'lib/codebreaker'
require_relative 'app/controllers/games_controller'
require_relative 'app/models/game'

rack_config = File.read(File.absolute_path('rack_config.rb'))
eval "#{rack_config}"
