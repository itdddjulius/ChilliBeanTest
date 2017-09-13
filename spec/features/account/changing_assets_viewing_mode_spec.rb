require 'rails_helper'

RSpec.feature 'Changing assets viewing mode' do
  before :each do
    @user = create(:user)
    @library = create(:library)
    @video_asset = create(:asset, library: @library, uploader: @user, file_type: :video, created_at: 4.weeks.ago)
    @image_asset = create(:asset, library: @library, uploader: @user, file_type: :image, created_at: 3.weeks.ago)
    @document_asset = create(:asset, library: @library, uploader: @user, file_type: :document, created_at: 2.weeks.ago)
    @audio_asset = create(:asset, library: @library, uploader: @user, file_type: :audio, created_at: 1.week.ago)
  end

  scenario 'default view is grid view' do
    sign_in_as(@user)

    visit library_path(@library)

    expect(page).to have_css('.asset', :count => 4)
    expect(page).to have_css('.display-options .grid.active')
  end

  scenario 'switching to list view' do
    sign_in_as(@user)

    visit library_path(@library)
    page.find('.display-options').find('.list').click

    expect(page).to have_css('.tr-asset-content', :count => 4)
    expect(page).to have_css('.display-options .list.active')
  end
end
