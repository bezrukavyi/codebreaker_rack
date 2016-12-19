use Rack::Static, root: 'public', urls: ['/images', '/js', '/css', '/fonts']
use Rack::Reloader
use Rack::Session::Cookie, :key => 'codebreaker.session',
                           :expire_after => 2592000,
                           :secret => 'codebreaker'
map '/' do
  use Codebreaker::Router
  run Codebreaker::App.new
end
