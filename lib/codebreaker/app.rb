module Codebreaker
  class App
    def call(env)
      @env = env
      dispatch
    end

    def dispatch
      controller.new(@env).send(action)
    end

    private
    def action
      @env[:app_action]
    end

    def controller
      controller = @env[:app_controller].capitalize + 'sController'
      Object.const_get(controller)
    end
  end
end
