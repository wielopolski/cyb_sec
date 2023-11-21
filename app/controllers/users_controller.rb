class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :authorize_admin, only: [:new, :create, :edit_password_by_admin, :update_password_by_admin]

  def new
    binding.pry
    @user = User.new
  end

  def create
    binding.pry
    # @user = User.new(create_user_params.merge(password_confirmation: create_user_params.password))
    # if @user.save
    #   binding.pry
    #   redirect_to users_path, notice: 'User was successfully created.'
    # else
    #   render :new
    # end
  end

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit_password_by_admin
    @user = User.find(params[:id])
  end

  def update_password_by_admin
    @user = User.find(params[:id])

    if user_password_update_params["password"] === user_password_update_params["password_confirmation"]
      @user.update_attribute(:password, user_password_update_params["password"])
      redirect_to users_path, notice: 'Password updated successfully.'
    else
      render :edit_password_by_admin
    end
  end

  def show_versions
    @user = User.find(params[:id])
    @versions = @user.versions
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end

  def create_user_params
    params.require(:user).permit(:email, :password)
  end

  def user_password_update_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def authorize_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user && current_user.is_admin
  end
end
