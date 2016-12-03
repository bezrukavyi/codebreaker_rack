require "rack_helper"

RSpec.feature "Widget management", :type => :feature do
  scenario "start game" do
    visit '/'
    click_on 'New game'
    expect(page).to have_content 'Guess code with numbers from 1 to 6'
  end
  context 'playing' do
    before do
      visit '/play'
      all_guess_inputs = page.all(:fillable_field, 'guess[]')
      all_guess_inputs.each{ |field| field.set('1') }
    end
    scenario "get progress after guess" do
      find('label', :text => 'Send').click
      expect(page).to have_content 'Progress'
      expect(page).not_to have_css 'div.guess-hint'
    end
    scenario "get hint after click on hint" do
      find('label', :text => 'Hint').click
      expect(page).to have_css 'div.guess-hint'
    end
    scenario "start new game" do
      old_game = page.driver.cookies['codebreaker.session']
      click_on 'New game'
      new_game = page.driver.cookies['codebreaker.session']
      expect(old_game).not_to eq(new_game)
      expect(page).not_to have_content 'Progress'
    end
  end
  context 'result of play' do
    before do
      allow_any_instance_of(Codeguessing::Game).to receive(:random).and_return('1111')
      visit '/play'
    end
    scenario "when loose" do
      all_guess_inputs = page.all(:fillable_field, 'guess[]')
      all_guess_inputs.each{ |field| field.set('1') }
      find('label', :text => 'Send').click
      page.save_screenshot('signed_in.png')
    end
  end
end
