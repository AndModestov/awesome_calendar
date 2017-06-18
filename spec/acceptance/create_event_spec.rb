require 'rails_helper'

feature 'User can create new event' do
  given(:user){ create(:user) }

  scenario 'Authenticated user try to answer the question', js: true do
    log_in(user)
    visit events_path
    find('a.new-event-link').click
    fill_in 'event_name', with: 'New Event Name'
    fill_in 'Starts at', with: '13-06-2017 21:30 +03:00'
    fill_in 'Ends at', with: '15-06-2017 21:30 +03:00'
    click_on 'Save'

    expect(current_path).to eq events_path
    within '#calendar' do
      expect(page).to have_content 'New Event Name'
    end
  end

  scenario 'Authenticated user try to create invalid answer', js: true do
    log_in(user)
    visit events_path
    find('a.new-event-link').click
    click_on 'Save'

    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Start time can't be blank"
    expect(page).to have_content "End time can't be blank"
  end

  scenario 'Non-Authenticated user try to answer the question' do
    visit events_path

    expect(page).to_not have_selector 'a.new-event-link'
  end
end
