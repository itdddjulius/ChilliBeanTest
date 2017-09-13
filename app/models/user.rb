class User < ApplicationRecord
  has_secure_password

  MIN_PASSWORD_LENGTH = 8
  PASSWORD_LIFETIME = 90

  acts_as_paranoid

  has_many :assets
  has_many :libraries, through: :library_users
  has_many :comments
  has_many :activities
  validates :email, uniqueness: true, presence: true
  validates_email_format_of :email
  validate :password_strength

  before_validation do
    self.email = email.to_s.downcase
  end

  before_create do
    self.token = SecureRandom.uuid
  end

  after_commit do
    if self.previous_changes.has_key?("password_digest")
      self.update_attributes(last_password_digest: password_digest)
    end
  end

  def fullname
    return name unless name.blank?
    return email
  end

  def change_password(current_password, new_password, new_password_confirmation)
    current_password_digest = self.password_digest
    if self.authenticate(current_password)
      if self.update_attributes(password: new_password, password_confirmation: new_password_confirmation, force_password_change: false, password_reset_date: DateTime.now, last_password_digest: current_password_digest)
        return self
      else
        return false
      end
    else
      self.errors.add(:password, "Incorrect")
      return false
    end
  end

  def password_expired?
    (DateTime.now - self.password_reset_date).to_i >= PASSWORD_LIFETIME
  end

  private
    def password_strength
      unless self.password.nil?
        if password_digest_changed?
          if self.last_password_digest && BCrypt::Password.new(self.last_password_digest) == self.password
            errors.add(:password, "must not be the same as last")
          end
          if self.password.length < MIN_PASSWORD_LENGTH
            errors.add(:password, "must be at least #{MIN_PASSWORD_LENGTH} characters long")
          end
          if self.password.match(/[A-Z]/).nil?
            errors.add(:password, "must have at least 1 uppercase character")
          end
          if self.password.match(/[0-9]/).nil? && self.password.match(/\W/).nil?
            errors.add(:password, "must have at least 1 numeric character or 1 special (non alphanumeric) character")
          end
        end
      end
    end
end
