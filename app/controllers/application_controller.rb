class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :require_otp_verified, if: :user_signed_in?, except: [:otp_verification]
  before_action :log_user_logout, if: :user_signed_in?, only: :destroy

  private

  def require_admin_role
    redirect_to root_path, notice: 'Only admins can manage teams' unless current_user.is_admin?
  end

  def require_otp_verified
    if current_user.otp_required_for_first_login? && !current_user.otp_verified?
      flash[:alert] = 'Please verify your OTP before accessing other page.'
      redirect_to otp_verification_user_path(current_user)
    end
  end

  def after_sign_in_path_for(resource)
    current_user.log_login
    '/'
  end

  def log_user_logout
    current_user.log_logout
  end
end
