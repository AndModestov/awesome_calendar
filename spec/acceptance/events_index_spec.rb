require 'rails_helper'

feature 'User can watch the events list' do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  start_time = Time.now.midday
  end_time = start_time + 2.hours
  given!(:event1) { create(:event, user: user1, start_time: start_time, end_time: end_time) }
  given!(:event2) { create(:event, user: user1, start_time: start_time, end_time: end_time) }
  given!(:event3) { create(:event, user: user2, start_time: start_time, end_time: end_time) }

  scenario 'Authenticated user trying to watch all events', js: true do
    log_in(user1)
    visit events_path

    expect(page).to have_link("12p #{event1.name}", href: "http://localhost:3000/events/#{event1.id}")
    expect(page).to have_link("12p #{event2.name}", href: "http://localhost:3000/events/#{event2.id}")
    expect(page).to have_link("12p #{event3.name}", href: "http://localhost:3000/events/#{event3.id}")
  end

  scenario 'Authenticated user trying to filter events', js: true do
    log_in(user1)
    visit events_path
    find('a#render_user_events').click

    expect(page).to have_link("12p #{event1.name}", href: "http://localhost:3000/events/#{event1.id}")
    expect(page).to have_link("12p #{event2.name}", href: "http://localhost:3000/events/#{event2.id}")
    expect(page).to_not have_link("12p #{event3.name}")

    find('a#render_all_events').click

    expect(page).to have_link("12p #{event1.name}", href: "http://localhost:3000/events/#{event1.id}")
    expect(page).to have_link("12p #{event2.name}", href: "http://localhost:3000/events/#{event2.id}")
    expect(page).to have_link("12p #{event3.name}", href: "http://localhost:3000/events/#{event3.id}")
  end

  scenario 'Non-Authenticated user trying to watch events', js: true do
    visit events_path

    expect(page).to have_text('You need to sign in or sign up before continuing.')
    expect(page).to_not have_link("12p #{event1.name}")
    expect(page).to_not have_link("12p #{event2.name}")
    expect(page).to_not have_link("12p #{event3.name}")
  end
end
