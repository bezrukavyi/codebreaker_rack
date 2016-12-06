require 'rack_helper'

describe GamesController do
  let(:env) { Rack::MockRequest.env_for('/') }
  subject { GamesController.new(env) }

  describe '#create' do
    let(:response) { subject.create }
    it 'must create new game' do
      expect(subject.game).to be_kind_of(Game)
    end
    it 'must redirect_to /play' do
      expect(response.header['Location']).to eq('/play')
    end
  end

  describe '#play' do
    before do
      allow(subject).to receive(:render)
      allow(subject).to receive(:parse_opt).and_return({ last_guess: '' })
    end
    it 'when hint param exist' do
      subject.request['hint'] = true
      subject.play
      expect(subject.hint).to match(/\d{1}/)
    end
    it 'when hint param missing' do
      subject.play
      expect(subject.hint).to eq(nil)
    end
  end

  describe '#update' do
    it 'when guess param exist' do
      old_attempts = subject.game.attempts
      subject.request['guess'] = [1, 2, 3, 4]
      subject.update
      new_attempts = subject.game.attempts
      expect(old_attempts).not_to eq(new_attempts)
    end
    it 'must redirect_to /update' do
      response = subject.update
      expect(response.header['Location']).to eq('/play')
    end
  end

  describe '#save' do
    let(:test_path) { File.expand_path('../../fixtures/test.yml', __FILE__) }
    let(:subject_scores) { subject.scores }

    before do
      allow(subject).to receive(:path).and_return(test_path)
      subject.request.session[:game] = 'test_game'
      subject.save
    end

    after do
      File.open(test_path, 'w') { |f| YAML.dump(f) }
    end

    it 'must be equal scores' do
      data_scores = YAML.load_file(test_path)
      expect(subject_scores).to eq(data_scores)
    end
    it 'must clear session game' do
      expect(subject.request.session[:game]).to eq('')
    end
  end

  describe '#game_exist?' do
    it 'when game exist' do
      subject.request.session[:game] = 'test'
      expect(subject.game_exist?).to be_truthy
    end
    it 'when game missing' do
      subject.request.session[:game] = []
      expect(subject.game_exist?).to be_falsey
    end
  end

end
