module Codebreaker
  class Router

    attr_reader :env

    ROUTES =  {
      '/':        'game#index',
      '/rules':   'game#rules',
      '/play':    'game#play',
      '/save':    'game#save',
      '/update':  'game#update',
      '/new':     'game#new'
    }

    def initialize(app)
      @app = app
    end

    def call(env)
      if route = ROUTES[env['PATH_INFO'].to_sym]
        env.merge!(controller_action(route))
        @app.call(env)
      else
        Rack::Response.new('Not found', 404)
      end
    end


    private
    def controller_action(route)
      Hash[ [:app_controller, :app_action].zip(route.split('#')) ]
    end
  end
end
