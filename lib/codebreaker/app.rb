module Codebreaker
  class App

    attr_reader :env

    def call(env)
      @env = env
      dispatch
    end

    def dispatch
      Object.const_get(controller).new(@env).send(action)
    end

    private

    def action
      env[:app_action]
    end

    def controller
      env[:app_controller].split('_').map(&:capitalize).join + 'sController'
    end
  end
end
