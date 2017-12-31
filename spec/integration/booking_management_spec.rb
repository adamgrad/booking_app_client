require "rails_helper"

RSpec.feature "Booking management", type: :feature do
  skip "Successfully creates booking", js: true do
    VCR.use_cassette("post_bookings") do
      visit "/rentals"
      expect(page).to have_content "Rental Test"
      find(:xpath, "//tr[td[contains(.,'Rental Test')]]/td/a", text: "Book").click
      expect(page).to have_content "You are currently booking: Rental Test"

      find("input[name='booking[start_at]']").click
      # expect(page).to have_content DateTime.now.strftime("%B")
      within(".ui-datepicker") { click_link Date.today.day.to_s }

      find("input[name='booking[end_at]']").click
      # expect(page).to have_content DateTime.now.strftime("%B")
      within(".ui-datepicker") { click_link(Date.today.day + 2).to_s }
      fill_in "Client email", with: "capybara@email.com"
      # click_button "Submit"
    end
  end
end
