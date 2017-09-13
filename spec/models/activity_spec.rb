require 'rails_helper'

RSpec.describe Activity, :type => :model do
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:user_email) }
end
