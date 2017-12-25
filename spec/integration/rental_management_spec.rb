require "rails_helper"

RSpec.feature "Rental management", type: :feature do
  scenario "Successfully creates rental" do
    VCR.use_cassette "post_rental" do
      visit root_path
      click_link "RENTALS"
      click_link "Create Rental"
      fill_in "Name", with: "RSpec Rental"
      fill_in "Daily rate", with: 122
      click_button "Create rental"
      expect(page).to have_content "Rental"
      expect(page).to have_content "RSpec Rental"
      expect(page).to have_content "122"
    end
  end

  scenario "Successfully edits rental" do
    VCR.use_cassette "patch_rental" do
      visit "/rentals"
      expect(page).to have_content "RSpec Rental"
      find(:xpath, "//tr[td[contains(.,'RSpec Rental')]]/td/a", :text => "Edit").click
      expect(page).to have_content "Edit Rental"
      fill_in "Name", with: "RSpec Changed"
      fill_in "Daily rate", with: 100
      click_button "Update"
      expect(page).not_to have_content "RSpec Rental"
      expect(page).to have_content "RSpec Changed"
    end
  end

  scenario "Successfully deletes rental" do
    VCR.use_cassette "delete_rental" do
      visit "/rentals"
      expect(page).to have_content "RSpec Changed"
      find(:xpath, "//tr[td[contains(.,'RSpec Changed')]]/td/a", :text => "Delete").click
      expect(page).not_to have_content "RSpec Changed"
      expect(page).not_to have_content "100"
    end
  end
end