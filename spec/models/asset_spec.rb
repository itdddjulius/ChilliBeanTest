require 'rails_helper'

RSpec.describe Asset, :type => :model do
  it { should belong_to(:library) }
  it { should belong_to(:uploader) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:filename) }
  it { should validate_presence_of(:library) }
  it { should validate_presence_of(:uploader) }
end
