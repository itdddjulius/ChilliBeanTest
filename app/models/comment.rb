class Comment < ApplicationRecord
  acts_as_paranoid

  belongs_to :asset, counter_cache: true
  belongs_to :author, class_name: "User"

  validates :comment, presence: true
  validates :author, presence: true

  before_create :sanitize_comment

  private
    def sanitize_comment
      coder = HTMLEntities.new
      self.comment = coder.encode(self.comment)
    end
end
