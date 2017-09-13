require 'rails_helper'

RSpec.describe CommentsController do
  before :each do
    @user = create(:user)
    @library = create(:library)
    @video_asset = create(:asset, library: @library, uploader: @user, file_type: :video)
    log_in_user(@user)
  end

  describe "GET index" do
    it "renders the comment index page" do
      get :index, params: { library_id: @library.id, asset_id: @video_asset.id }

      expect(response).to render_template(:index)
    end
  end
end
