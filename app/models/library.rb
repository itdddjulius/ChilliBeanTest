class Library < ApplicationRecord
  acts_as_paranoid

  has_many :assets
  has_many :activities
  has_many :recent_activities, ->{ limit(3).order("created_at DESC") }, class_name: "Activity"
  belongs_to :creator, class_name: "User"

  validates :name, presence: true

  def self.alphabetical
    order("name ASC")
  end
end
