class UsersController < ApplicationController
  def new
    @titre = "Inscription"
  end
  def show
    @user = User.find(params[:id])
  end
end
