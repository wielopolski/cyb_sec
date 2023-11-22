# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  before_action :check_failed_attempts, only: :create

  def create
    self.resource = warden.authenticate(auth_options)
    if resource && resource.valid_password?(params[:user][:password])
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      respond_with resource, location: new_user_session_path
    end
  end


  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private
  def after_timeout_path_for(_resource)
    # Customize the path where users should be redirected after a timeout
    root_path
  end

  def check_failed_attempts
    user = User.find_by(email: params[:user][:email].downcase)
    return unless user
    # user.unlock_access!

    if user.access_locked?
      remaining_time = (user.locked_at + Devise.unlock_in) - Time.current
      flash[:alert] = "Your account is locked. Please contact support. It will be automatically unlocked in #{remaining_time}."
      redirect_to new_user_session_path
    elsif !user.valid_password?(params[:user][:password])
      user.increment_failed_attempts
      remaining_attempts = User.maximum_attempts - user.failed_attempts
      flash[:alert] = "Invalid email or password. #{remaining_attempts} attempts remaining."
    else
      user.reset_failed_attempts!
    end
  end
end
