# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  first_name      :string           not null
#  last_name       :string           not null
#  email           :string
#  mobile_number   :string
#  birth_date      :date             not null
#  gender          :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'date'

class User < ApplicationRecord
  validates :first_name, uniqueness: {scope: [:last_name]}
  validates :first_name, :last_name, presence: true
  validates :email, :mobile_number, uniqueness: true, allow_nil: true
  validate :valid_birthdate
  validates :gender, presence: true
  validates :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validate :ensure_profile_photo
  validate :email_or_mobile_number
  after_initialize :ensure_session_token

  has_many :authored_posts,
    foreign_key: :author_id,
    class_name: :Post,
    dependent: :delete_all

  has_many :page_posts,
    foreign_key: :page_id,
    class_name: :Post,
    dependent: :delete_all

  has_many :authored_comments,
    foreign_key: :author_id,
    class_name: :Comment,
    dependent: :delete_all

  has_many :outgoing_relationships,
    foreign_key: :user1_id,
    class_name: :UserRelationship,
    dependent: :delete_all

  has_many :incoming_relationships,
    foreign_key: :user2_id,
    class_name: :UserRelationship,
    dependent: :delete_all

  has_one_attached :profile_photo

  attr_reader :password
  attr_accessor :year, :month, :day

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email)
    return user if user && user.is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  private

  def email_or_mobile_number
    if (email.nil? || email.empty?) && (mobile_number.nil? || mobile_number.empty?)
      errors[:email] << "Email or Mobile Number Required"
    end
  end

  def sanitize_mobile(mobile_number)
    mobile_number.delete('^0-9')
  end

  def valid_birthdate
    unless self.birth_date
      begin
        birth_date = "#{@year}-#{@month}-#{@day}"
        Date.parse(birth_date)
        self.birth_date = birth_date
      rescue ArgumentError
        errors[:birth_date] << "is invalid"
      end
    end
  end

  def ensure_profile_photo
    unless self.profile_photo.attached?
      errors[:profile_photo] << "Photo must be attached"
    end
  end

end
