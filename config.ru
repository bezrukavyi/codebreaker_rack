require_relative 'lib/codebreaker'
require_relative 'app/controllers/games_controller'
require_relative 'app/models/game'

use Rack::Static, root: 'public', urls: ['/images', '/js', '/css', '/fonts']
use Rack::Reloader
use Rack::Session::Cookie, :key => 'codebreaker.session',
                           :expire_after => 2592000,
                           :secret => 'codebreaker'


use Codebreaker::Router
run Codebreaker::App.new
