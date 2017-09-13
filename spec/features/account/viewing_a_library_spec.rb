require 'rails_helper'

RSpec.feature 'Viewing a Library' do
  before :each do
    @user = create(:user)
    @library = create(:library)
    @video_asset = create(:asset, library: @library, uploader: @user, file_type: :video, created_at: 5.weeks.ago, filename: "video.mp4")
    @image_asset = create(:asset, library: @library, uploader: @user, file_type: :image, created_at: 3.weeks.ago, filename: "image.jpg")
    @document_asset = create(:asset, library: @library, uploader: @user, file_type: :document, created_at: 2.weeks.ago, filename: "document.pdf")
    @audio_asset = create(:asset, library: @library, uploader: @user, file_type: :audio, created_at: 1.week.ago, filename: "audio.mp3")
  end

  scenario 'Assets ordered by default newest to oldest' do
    sign_in_as(@user)

    visit library_path(@library)
    page.find(".asset", match: :first)
    all_assets = page.all(".asset")
    expect(all_assets[0]["id"]).to eql("asset-#{@audio_asset.id}")
    expect(all_assets[1]["id"]).to eql("asset-#{@document_asset.id}")
    expect(all_assets[2]["id"]).to eql("asset-#{@image_asset.id}")
    expect(all_assets[3]["id"]).to eql("asset-#{@video_asset.id}")
  end

  scenario 'Asset file type icons displayed' do
    sign_in_as(@user)

    visit library_path(@library)

    expect(page).to have_css("#asset-#{@video_asset.id} .asset-badges.file-type-badge.video")
    expect(page).to have_css("#asset-#{@image_asset.id} .asset-badges.file-type-badge.image")
    expect(page).to have_css("#asset-#{@document_asset.id} .asset-badges.file-type-badge.document")
    expect(page).to have_css("#asset-#{@audio_asset.id} .asset-badges.file-type-badge.audio")
  end

  scenario 'the library has no assets' do
    Asset.all.each { |a| a.destroy }
    sign_in_as(@user)

    visit library_path(@library)

    expect(page).to have_content('Welcome to Your New Library!')
    expect(page).to have_content('To get started, upload content using the bar above, then organize it into collections using the menu on the left.')
  end
end
