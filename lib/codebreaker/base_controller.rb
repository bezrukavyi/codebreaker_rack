module Codebreaker
  class BaseController

    def initialize(env)
      @env = env
    end

    def render(view_name, &block)
      content = get_view(view_name)
      content = ERB.new(content).result(binding)
      return content if view_name.split('/')[1][0] == '_'

      layout = get_view('layouts/application')
      layout = ERB.new(layout).result(binding)
      Rack::Response.new(layout) { |resp| block.call(resp) if block_given?  }
    end

    def redirect_to(path)
      Rack::Response.new { |resp| resp.redirect(path) }
    end

    private
    def get_view(name = 'layouts/application')
      File.read("app/views/#{name}.html.erb")
    end
  end
end
