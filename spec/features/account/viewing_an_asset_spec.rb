require 'rails_helper'

RSpec.feature 'Viewing an Asset' do
  before :each do
    @user = create(:user)
    @library = create(:library)
    @video_asset = create(:asset, library: @library, uploader: @user, filename: "video.mp4", file_type: :video)
    @image_asset = create(:asset, library: @library, uploader: @user, filename: "image.jpg", file_type: :image)
    @document_asset = create(:asset, library: @library, uploader: @user, filename: "document.pdf", file_type: :document)
    @audio_asset = create(:asset, library: @library, uploader: @user, filename: "audio.mp3", file_type: :audio)
    @unknown_asset = create(:asset, library: @library, uploader: @user, filename: "unknown.unkn")
  end

  context 'the asset is a video file' do
    scenario 'it has media info' do
      @video_asset.update_attributes(media_info: { channels: 2 }.to_json)
      sign_in_as(@user)

      visit library_asset_path(@library, @video_asset)

      expect(page).to have_content("Show Additional Info")
    end

    scenario 'it does not have media info' do
      sign_in_as(@user)

      visit library_asset_path(@library, @video_asset)

      expect(page).to_not have_content("Show Additional Info")
    end
  end

  context 'the asset is an audio file' do
    scenario 'it has media info' do
      @audio_asset.update_attributes(media_info: { channels: 2 }.to_json)

      sign_in_as(@user)

      visit library_asset_path(@library, @audio_asset)

      expect(page).to have_content("Show Additional Info")
    end

    scenario 'it does not have media info' do
      sign_in_as(@user)

      visit library_asset_path(@library, @audio_asset)

      expect(page).to_not have_content("Show Additional Info")
    end
  end

  scenario 'the asset is an image file' do
    sign_in_as(@user)

    visit library_asset_path(@library, @image_asset)

    expect(page).to_not have_content("Show Additional Info")
  end

  scenario 'the asset is a document file' do
    sign_in_as(@user)

    visit library_asset_path(@library, @document_asset)

    expect(page).to_not have_content("Show Additional Info")
  end

  scenario 'the asset is an unknown file type' do
    sign_in_as(@user)

    visit library_asset_path(@library, @unknown_asset)

    expect(page).to_not have_content("Show Additional Info")
  end

  scenario 'Image asset displays an image thumbnail' do
    sign_in_as(@user)

    visit library_asset_path(@library, @image_asset)

    expect(page).to have_no_css("#asset-wrap #asset-video-player")
    expect(page).to have_selector("#asset-wrap img")
  end

  scenario 'Unknown asset type displays a placeholder image' do
    sign_in_as(@user)

    visit library_asset_path(@library, @unknown_asset)

    expect(page).to have_no_css("#asset-wrap #asset-video-player")
    expect(page).to have_selector("#asset-wrap img.unknown")
  end
end