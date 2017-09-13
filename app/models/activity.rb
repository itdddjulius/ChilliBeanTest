class Activity < ApplicationRecord
  acts_as_paranoid
  
  validates :action, presence: true
  validates :user_id, presence: true
  validates :user_email, presence: true

  belongs_to :user
  belongs_to :library, touch: true

  self.per_page = 10
end

