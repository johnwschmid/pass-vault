class SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pw, only: [:create]
  def new
    @user_password = UserPassword.new
    @users = User.excluding(current_user)
  end
  def create
    @user_password = @password.user_passwords.create(user_id: params[:user_password][:user_id])
    if @user_password.persisted?
      redirect_to password_path(params[:password_id])
    else
      render :new
    end
  end
  def destroy
    UserPassword.where(user_id: current_user, password_id: params[:password_id]).first.destroy
    redirect_to password_path(params[:password_id])
  end

  private
  def set_pw
    @password = Password.find(params[:password_id])
  end
end