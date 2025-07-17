class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pw, only: [:show, :edit, :update, :destroy]
  before_action :require_editor_permits, only: [:edit, :update]
  before_action :require_owner_permits, only: [:destroy]

  def index
    @passwords = current_user.passwords
  end
  def edit
  end
  def show
    @user_pw = @password.user_passwords.find_by(user: current_user)
  end
  def new
    @password = Password.new
  end
  def create
    @password = Password.new(password_params)
    @password.user_passwords.new(user: current_user, role: :owner)
    if @password.save!
      redirect_to @password, alert: 'success'
    else
      render :new, status: :unprocessable_entity
    end
  end
  def update
    if @password.update(password_params)
      redirect_to @password
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @password.destroy
    redirect_to :passwords
  end

  private
  def password_params
    params.require(:password).permit(:url, :username, :password)
  end
  def set_pw
    @password = Password.find(params[:id])
  end
  def require_editor_permits
    unless @password.editable_by?(current_user)
      redirect_to @password, alert: 'Do not have edit permissions'
    end
  end
  def require_owner_permits
    unless @password.owned_by?(current_user)
      redirect_to @password, alert: 'Need password owner permissions'
    end
  end
end