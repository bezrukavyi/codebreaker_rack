require 'rack_helper'

describe Codebreaker::BaseController do
  let(:env) { Rack::MockRequest.env_for('/') }
  subject { Codebreaker::BaseController.new(env) }

  it '#redirect_to' do
    path = '/'
    response = subject.redirect_to(path)
    expect(response.header['Location']).to eq(path)
  end

  describe '#render' do
    let(:test_content) { "test\n" }
    before do
      path = File.expand_path('../../', __FILE__)
      test_file = File.read("#{path}/fixtures/test.html.erb")
      allow(subject).to receive(:get_view).and_return(test_file)
    end
    it 'render template' do
      response = subject.render('test/test')
      expect(response.body).to eq([test_content])
    end
    it 'render parts' do
      response = subject.render('test/_test')
      expect(response).to eq(test_content)
    end
  end

end
