require 'rack_helper'

describe Codebreaker::App do
  let(:middleware) { Codebreaker::Router.new(subject) }
  let(:request) { Rack::MockRequest.new(subject) }

  describe '#controller' do
    before do
      env = Rack::MockRequest.env_for('/')
      middleware.call(env)
    end

    context "#controller" do
      it 'simple name' do
        allow(subject).to receive(:env).and_return({app_controller: 'game'})
        expect(subject.send(:controller)).to eq('GamesController')
      end
      it 'name with underline' do
        allow(subject).to receive(:env).and_return({app_controller: 'simple_page'})
        expect(subject.send(:controller)).to eq('SimplePagesController')
      end
    end
  end
end
