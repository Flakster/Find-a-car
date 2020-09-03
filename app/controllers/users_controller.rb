class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    json_response(@users)
  end

  # POST /users
  def create
    @user = User.create!(users_params)
    json_response(@user, :created)
  end

  # GET /users/:id
  def show
    json_response(@user)
  end

  # PUT /users/:id
  def update
    @user.update(users_params)
    head :no_content
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    head :no_content
  end

  private

  def users_params
    # whitelist params
    params.permit( :name )
  end

  def set_user
    @user = User.find(params[:id])
  end
end
