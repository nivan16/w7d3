class UsersController < ApplicationController
  before_action :ensure_logged_in, only: {}
  
  def index
    @users = User.all
    render :index
  end
  
  def show
    @user = User.find(params[:id])
    render :show
  end

  def new 
    @user = User.new
    render :new
  end
  
  def create
    @user = User.create(user_params)
    if @user.save
      log_in!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    render :edit
  end

  def update
    @user = User.create(user_params)
    if @user.save
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end