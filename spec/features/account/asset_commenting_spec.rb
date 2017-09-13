require 'rails_helper'

RSpec.feature 'Asset commenting' do
  before :each do
    @user = create(:user)

    @library = create(:library)
    @asset = create(:asset, library: @library, uploader: @user)
  end

  before :each do |example|
    if example.metadata[:js]
      Capybara.run_server = true #Whether start server when testing
      Capybara.server_port = 8200
      Capybara.app_host = "http://js.example.com:8200"
    end
  end

  after :each do |example|
    if example.metadata[:js]
      Capybara.run_server = false
    end
  end

  scenario 'User adds a comment on an Asset' do
    sign_in_as(@user)

    visit library_asset_path(@library, @asset)
    click_link "Comments"
    expect(page).to have_text("Comments (0)")
    fill_in "Comment", with: "This is my comment."
    click_on "Add Comment"
    expect(page).to have_text("This is my comment.")
    expect(page).to have_text("Comments (1)")
  end

  scenario 'User tries to add a comment without any text' do
    sign_in_as(@user)

    visit library_asset_path(@library, @asset)
    click_link "Comments"
    click_on "Add Comment"
    expect(page).to have_text("Comment can't be blank")
  end
end
