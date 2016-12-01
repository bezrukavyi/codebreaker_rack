require 'rack_helper'

describe Codebreaker::App do
  subject { Codebreaker::App.new }
  let(:middleware) { Codebreaker::Router.new(subject) }
  let(:request) { Rack::MockRequest.new(subject) }

  describe '#controller' do
    before do
      env = Rack::MockRequest.env_for('/')
      middleware.call(env)
    end
    # let(:controller) { subject.send(:controller) }

    it "must return Class" do
      # expect(controller).to be_kind_of(Class)
    end
  end
end
