require 'rails_helper'

feature 'Edit user' do
  given(:user){ create(:user) }

  scenario 'Edit user with valid data' do
    log_in(user)
    visit edit_user_registration_path(user)

    fill_in 'Name', with: 'New Name'
    fill_in 'Email', with: 'new@email.com'
    fill_in 'Current password', with: user.password
    click_on 'Update'

    expect(page).to have_content 'Your account has been updated successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Edit user with invalid data' do
    log_in(user)
    visit edit_user_registration_path(user)

    fill_in 'Name', with: 'New Name'
    fill_in 'Email', with: ''
    fill_in 'Current password', with: ''
    click_on 'Update'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content 'Email is invalid'
    expect(page).to have_content "Current password can't be blank"
  end
end
