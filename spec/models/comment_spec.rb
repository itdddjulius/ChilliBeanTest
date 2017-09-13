require 'rails_helper'

RSpec.describe Comment do
  it { should belong_to(:asset).counter_cache(true) }
  it { should belong_to(:author).class_name("User") }

  it { should validate_presence_of(:comment) }
  it { should validate_presence_of(:author) }
end
