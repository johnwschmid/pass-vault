class SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pw, only: [:create, :new]
  before_action :require_owner_permits, only: [:new, :create, :destroy]
  def new
    @user_password = UserPassword.new
  end
  def create
    @user_password = @password.user_passwords.new(shares_params)
    if @user_password.save
      redirect_to password_path(params[:password_id])
    else
      render :new
    end
  end
  def destroy
    UserPassword.where(user_id: params[:id]).destroy_all
    redirect_to password_path(params[:password_id])
  end

  private
  def set_pw
    @password = Password.find(params[:password_id])
  end
  def shares_params
    params.require(:user_password).permit(:user_id, :role) 
  end
  def require_owner_permits
    @password.owned_by?(current_user)
  end
end