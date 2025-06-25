class PasswordsController < ApplicationController
  before_action :authenticate_user!
  def index
    @passwords = current_user.passwords
  end
  def show
    @password = current_user.passwords.find(params[:id])
  end
  def new
    @password = Password.new
  end
  def create
    @password = current_user.passwords.create(password_params)
    if @password.persisted?
      redirect_to @password
    else
      render :new, status: :unprocessible_entity
    end
  end

  private
  def password_params
    params.require(:password).permit(:url, :username, :password)
  end
end