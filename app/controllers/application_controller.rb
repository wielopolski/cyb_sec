class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :log_user_logout, if: :user_signed_in?, only: :destroy

  private

  def require_admin_role
    redirect_to root_path, notice: 'Only admins can manage teams' unless current_user.is_admin?
  end

  def after_sign_in_path_for(resource)
    current_user.log_login
    super(resource)
  end

  def log_user_logout
    current_user.log_logout
  end
end
