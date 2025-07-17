class SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pw
  before_action :require_owner_permits, only: [:destroy]
  before_action :require_editor_permits, only: [:new, :create]
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
    unless @password.owned_by?(current_user)
      redirect_to @password, alert: 'Need password ownership permissions'
    end
  end
  def require_editor_permits
    unless @password.editable_by?(current_user)
      redirect_to @password, alert: 'Do not have edit permissions'
    end
  end
end