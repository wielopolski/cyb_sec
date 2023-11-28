# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super do |user|
      # Your additional logic after creating a user, e.g., sending a welcome email

      # Set up OTP for the user during registration
      # binding.pry
      user.generate_otp_secret_key
      user.save
      redirect_to new_user_session_path, notice: "Please log in for the first time."
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    # binding.pry
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    unless verify_recaptcha(model: resource)
      flash[:alert] = 'reCAPTCHA verification failed. Please try again.'
      return redirect_to edit_user_registration_path(resource), flash: { alert: flash[:alert] }
    end

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      # binding.pry
      set_flash_message_for_update(resource, t('devise.passwords.updated_not_active'))
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      # binding.pry
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:password, :password_confirmation, :current_password])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
