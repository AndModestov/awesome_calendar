require 'rails_helper'

feature 'User can edit the event' do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:event1) { create(:event, user: user1) }
  given!(:event2) { create(:event, user: user2) }

  scenario 'Authenticated user trying to edit his own event', js: true do
    log_in(user1)
    visit event_path event1
    find('a.new-event-link').click

    expect(page).to have_selector(:xpath, "//input[@value='#{event1.name}']")
    expect(page).to have_selector(:xpath, "//input[@data-date='#{event1.formatted_start_time}']")
    expect(page).to have_selector(:xpath, "//input[@data-date='#{event1.formatted_end_time}']")
    expect(page).to have_selector('select#event_repeat')

    fill_in 'Name', with: 'New event name'
    fill_in 'Starts at', with: '13-06-2017 21:30 +03:00'
    fill_in 'Ends at', with: '15-06-2017 21:30 +03:00'
    find('select#event_repeat').find(:xpath, 'option[3]').select_option
    click_on 'Save'

    expect(page).to have_selector(:xpath, "//h1[text()='New event name']")
    expect(page).to have_selector(:xpath, "//tr/td[text()='21:30']")
    expect(page).to have_selector(:xpath, "//tr/td[text()='48 hours']")
    expect(page).to have_selector(:xpath, "//tr/td[text()='every week']")
  end

  scenario 'Authenticated user trying to edit his own event with invalid data', js: true do
    log_in(user1)
    visit event_path event1
    find('a.new-event-link').click

    fill_in 'Name', with: ''
    fill_in 'Starts at', with: ''
    fill_in 'Ends at', with: ''
    click_on 'Save'

    expect(page).to have_text("Name can't be blank")
    expect(page).to have_text("Start time can't be blank")
    expect(page).to have_text("End time can't be blank")
  end

  scenario 'Authenticated user trying to edit other users event', js: true do
    log_in(user1)
    visit event_path event2

    expect(page).to_not have_selector('a.new-event-link')
  end
end
