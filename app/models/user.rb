class User < ApplicationRecord
  has_paper_trail

  has_many :bets

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  def full_name
    "#{first_name} #{last_name}"
  end

  def round_total_points(round)
    bets.joins(:match).where(match: { round_id: round.id }).sum(:points)
  end

  def total_points
    bets.sum(:points)
  end

  def log_login
    self.update_columns(login_status: 'login') # Optional: you can add a column to track login status
    self.paper_trail.save_with_version
  end

  def log_logout
    binding.pry
    self.update_columns(login_status: 'logout')
    self.paper_trail.save_with_version
  end
end
