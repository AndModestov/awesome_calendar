require 'rails_helper'

feature 'User can watch the event' do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:event1) { create(:event, user: user1) }
  given!(:event2) { create(:event, user: user2) }

  scenario 'Authenticated user trying to watch his own event', js: true do
    log_in(user1)
    visit event_path event1

    expect(page).to have_content(event1.name)
    expect(page).to have_content(user1.email)
    expect(page).to have_content(event1.start_time.localtime.strftime('%H:%M'))
    expect(page).to have_content(event1.duration)
    expect(page).to have_selector('a.new-event-link')
  end

  scenario 'Authenticated user trying to watch other users event', js: true do
    log_in(user1)
    visit event_path event2

    expect(page).to have_content(event2.name)
    expect(page).to have_content(user2.email)
    expect(page).to have_content(event2.start_time.localtime.strftime('%H:%M'))
    expect(page).to have_content(event2.duration)
    expect(page).to_not have_selector('a.new-event-link')
  end

  scenario 'Non-Authenticated user trying to watch event', js: true do
    visit event_path event1

    expect(page).to have_text('You need to sign in or sign up before continuing.')
    expect(page).to_not have_content(event1.name)
    expect(page).to_not have_content(user1.email)
    expect(page).to_not have_content(event1.start_time.localtime.strftime('%H:%M'))
    expect(page).to_not have_content(event1.duration)
    expect(page).to_not have_selector('a.new-event-link')
  end
end
