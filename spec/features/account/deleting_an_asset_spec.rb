require 'rails_helper'

RSpec.feature 'Deleting assets' do
  before :each do
    @user = create(:user)
    @library = create(:library)
    @asset = create(:asset, library: @library, uploader: @user, file_type: :image, created_at: 3.weeks.ago)
    sign_in_as(@user)
  end

  scenario 'deleting selected assets in the library', js: true do
    visit library_path(@library)
    page.find(".select-all").check("Select All")
    click_link("Delete")

    expect(page).to have_content("Delete the selected Assets from the Library?")

    page.find("#delete-assets-form button", text: "Delete").click

    expect(page).to have_content("Assets Deleted")
    expect(page).to_not have_selector("#assets .asset")
  end
end
