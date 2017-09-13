require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  describe "current_user" do
    it "returns a user" do
      expect(subject.current_user).to eq(User.first)
    end
  end
end
