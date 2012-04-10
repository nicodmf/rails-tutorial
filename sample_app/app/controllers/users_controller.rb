class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :visitor,      :only => [:new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  def new
    @user = User.new
    @titre = "Inscription"
  end

  def index
    @titre = "Tous les utilisateurs"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @titre = @user.nom
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      deny_access_user(users_path, "Vous ne pouvez realiser cette action")
    else
      @user.destroy
      flash[:success] = "Utilisateur supprime."
      redirect_to users_path
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # Traite un succès d'enregistrement.
      sign_in @user
      flash[:success] = "Bienvenue dans l'Application Exemple!"
      redirect_to @user
    else
      @user.password="";
      @titre = "Inscription"
      render 'new'
    end
  end

  def edit
    @titre = "Edition profil"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profil actualise."
      redirect_to @user
    else
      @titre = "Edition profil"
      render 'edit'
    end
  end

  private

  def visitor
    deny_access_user(root_path) unless !signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    deny_access_user unless current_user.admin?
  end

end

