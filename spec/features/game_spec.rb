require "rack_helper"

RSpec.feature "Game process", :type => :feature do

  context "main page" do
    scenario 'when game exist' do
      visit '/play'
      visit '/'
      expect(page).to have_content 'New game'
      expect(page).to have_content 'Continue game'
    end
    scenario "when game doesn't exist" do
      visit '/'
      expect(page).not_to have_content 'Continue game'
    end
    scenario 'start play' do
      visit '/'
      click_on 'New game'
      expect(page).to have_content 'Guess code with numbers from 1 to 6'
    end
  end

  context 'playing' do
    before do
      visit '/play'
      all_guess_inputs = page.all(:fillable_field, 'guess[]')
      all_guess_inputs.each{ |field| field.set('1') }
    end
    scenario 'get progress after guess' do
      find('label', :text => 'Send').click
      expect(page).to have_content 'Progress'
      expect(page).not_to have_css 'div.guess-hint'
    end
    scenario 'get hint after click on hint' do
      find('label', :text => 'Hint').click
      expect(page).to have_css 'div.guess-hint'
    end
    scenario 'start new game' do
      old_game = page.driver.cookies['codebreaker.session']
      click_on 'New game'
      new_game = page.driver.cookies['codebreaker.session']
      expect(old_game).not_to eq(new_game)
      expect(page).not_to have_content 'Progress'
    end
  end

  context 'result of play' do
    before do
      allow_any_instance_of(Game).to receive(:random).and_return('1111')
      visit '/play'
    end
    context 'win process' do
      let(:test_path) { File.expand_path('../../fixtures/test.yml', __FILE__) }

      before do
        all_guess_inputs = page.all(:fillable_field, 'guess[]')
        all_guess_inputs.each{ |field| field.set('1') }
        find('label', :text => 'Send').click
      end

      after do
        File.open(test_path, 'w') { |f| YAML.dump(f) }
      end

      it 'win page' do
        expect(page).to have_content 'You win!'
        expect(page).to have_css 'form.save-form'
      end
      it 'save result' do
        allow_any_instance_of(GamesController).to receive(:path).and_return(test_path)
        fill_in 'player', with: 'Test Name'
        click_on 'Save result'
        page.save_screenshot('signed_in.png')
      end
    end

    scenario 'when loose' do
      Game::MAX_ATTEMPTS.times do
        all_guess_inputs = page.all(:fillable_field, 'guess[]')
        all_guess_inputs.each{ |field| field.set('2') }
        find('label', :text => 'Send').click
      end
      expect(page).to have_content 'You loose!'
      expect(page).not_to have_css 'form.save-form'
    end
    scenario 'must be button new game' do
      expect(page).to have_content 'New game'
    end
  end

  scenario 'page of rules' do
    visit '/rules'
    expect(page).to have_content 'Rules'
    expect(page).to have_content 'To main page'
  end
end
