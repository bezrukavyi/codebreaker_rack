require "rack_helper"

RSpec.feature "Simple pages", :type => :feature do
  scenario 'page of rules' do
    visit '/rules'
    expect(page).to have_content 'Rules'
    expect(page).to have_content 'To main page'
  end
end
