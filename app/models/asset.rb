class Asset < ApplicationRecord
  acts_as_paranoid column: :soft_deleted_at

  belongs_to :library, counter_cache: true
  belongs_to :uploader, class_name: "User"
  has_many :comments, -> { includes(:author) }

  enum file_type: [:video, :image, :audio, :document, :unknown]

  validates :filename, presence: true
  validates :library, presence: true
  validates :uploader, presence: true

  self.per_page = 50

  before_create :set_file_type

  def asset_deleted
    self.soft_deleted_at.present?
  end

  def activity
    AssetActivity.where(activity_object_id: self.id)
  end

  private
    def set_file_type
      inspector = MediaInspector.new(self)
      self.file_type = inspector.media_type
    end
end
