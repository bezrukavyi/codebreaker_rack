require 'rack_helper'

describe Codebreaker::Router do
  let(:app) { MockRackApp.new }
  subject { Codebreaker::Router.new(app) }
  let(:request) { Rack::MockRequest.new(subject) }


  context 'GET' do
    it "path invalid" do
      response = request.get('/invalid_test_path')
      expect(response.status).to eq(404)
    end
    it "path valid" do
      env = Rack::MockRequest.env_for('/')
      subject.call(env)
      expect(app[:app_controller]).not_to eq(nil)
      expect(app[:app_action]).not_to eq(nil)
    end
    it "path '/play'" do
      env = Rack::MockRequest.env_for('/play')
      subject.call(env)
      expect(app[:app_controller]).to eq('game')
      expect(app[:app_action]).to eq('play')
    end
  end
end
