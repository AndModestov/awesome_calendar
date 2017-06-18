
require 'rails_helper'

feature 'Sign out user' do
  given(:user){ create(:user) }

  scenario 'Signed in user try to sign out' do
    log_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
