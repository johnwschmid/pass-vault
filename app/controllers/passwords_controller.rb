class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pw, only: [:edit, :update, :destroy]
  before_action :require_edit_permits, only: [:edit, :update]

  def index
    @passwords = current_user.passwords
  end
  def edit
  end
  def show
    @password = Password.find(params[:id])
  end
  def new
    @password = Password.new
  end
  def create
    @password = Password.new(password_params)
    @password.user_passwords.new(user: current_user, role: :owner)
    if @password.save!
      redirect_to @password
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
    @password = current_user.passwords.find(params[:id])
  end
  def require_edit_permits
    @password.editable_by?(current_user)
  end
end