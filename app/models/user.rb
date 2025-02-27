require 'matrix'

class User < ApplicationRecord
  include SimpleCaptcha::ModelHelpers

  has_paper_trail

  has_many :bets
  before_create :generate_otp_secret_key

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :lockable,
         :timeoutable, timeout_in: 2.minutes

  has_one_attached :avatar

  after_initialize :set_defaults

  attr_accessor :otp_code

  def full_name
    "#{first_name} #{last_name}"
  end

  def round_total_points(round)
    bets.joins(:match).where(match: { round_id: round.id }).sum(:points)
  end

  def total_points
    bets.sum(:points)
  end

  def change_password
    self.update_columns(login_status: 'change password') # Optional: you can add a column to track login status
    self.paper_trail.save_with_version
  end

  def log_login
    self.update_columns(login_status: 'login') # Optional: you can add a column to track login status
    self.paper_trail.save_with_version
  end

  def log_logout
    self.update_columns(login_status: 'logout')
    self.paper_trail.save_with_version
  end

  def lock_access!
    self.failed_attempts = 0
    self.locked_at = Time.current
    self.unlock_token = nil # Reset the unlock token
    save(validate: false) # Save without validations to avoid issues with other fields

  end

  def increment_failed_attempts
    update_attribute(:failed_attempts, failed_attempts + 1)
  end

  def generate_otp_secret_key
    self.otp_random_number = SecureRandom.random_number(0...199)
    self.otp_verified = false
  end

  def set_defaults
    self.otp_verified ||= false
    self.first_login ||= true
  end

  def otp_required_for_first_login?
    !otp_verified? && first_login?
  end

end
