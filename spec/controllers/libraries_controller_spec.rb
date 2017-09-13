require 'rails_helper'

RSpec.describe LibrariesController, :type => :controller do
  before :each do
    @user = create(:user)
    log_in_user(@user)
  end

  describe "GET index" do
    context "when User has access to only one Library" do
      it "redirects to the Library" do
        create(:library)

        get :index

        expect(response).to redirect_to(library_url(Library.first))
      end
    end
  end

  describe "GET show" do
    before :each do
      @library = create(:library)
    end

    context "without search, filter or sorting parameters" do
      it "assigns @assets" do
        assets = create_list(:asset, 5, library: @library, uploader: @user)

        get :show, params: { id: @library.id }

        expect(assigns[:assets].collect{|a| a.id}).to eql(@library.assets.order(created_at: :desc).collect{|a| a.id})
      end
    end

    it "renders the 'show' template" do
      get :show, params: { id: @library.id }
      expect(response).to render_template(:show)
    end

    it "returns a 200 OK status" do
      get :show, params: { id: @library.id }
      expect(response).to be_ok
    end
  end
end
