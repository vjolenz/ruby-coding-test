class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.create(user_params)
    redirect_to @user, notice: 'User was successfully created.'
  end

  # PATCH/PUT /users/1
  def update
    @user.update(user_params)
    redirect_to @user, notice: 'User was successfully updated.'
  end

  # DELETE /users/1
  def destroy
    @user.destroy unless @user.is_admin?
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.where(id: params[:id]).first
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :last_name)
  end
end
