require 'rails_helper'

RSpec.feature 'Editing asset info' do
  before :each do
    @user = create(:user)
    @library = create(:library)
    @asset = create(:asset, library: @library, uploader: @user)
  end

  context 'editing the asset info with non-blank values' do
    scenario 'updating the asset info', js: true do
      sign_in_as(@user)
      visit library_asset_path(@library, @asset)

      fill_in "Title", with: "test asset title"
      click_on "Update Asset"

      visit library_asset_path(@library, @asset)

      expect(page).to have_content("test asset title")
    end

    scenario 'viewing the activity', js: true do
      sign_in_as(@user)
      visit library_asset_path(@library, @asset)

      fill_in "Title", with: "test asset title"
      click_on "Update Asset"
      visit library_asset_path(@library, @asset)
      click_on "Activity"

      expect(page).to have_content("You updated test asset title's information:")
    end
  end
end
