require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "devrait reussir" do
      get :new
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get :new
      response.should have_selector("title", :content => "Inscription")
    end
    it "devrait avoir un champ nom" do
      get :new
      response.should have_selector("input[name='user[nom]'][type='text']")
    end
    it "devrait avoir un champ email" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    it "devrait avoir un champ mot de passe" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    it "devrait avoir un champ confirmation du mot de passe" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    it "devrait reussir" do
      get :show, :id => @user
      response.should be_success
    end
    it "devrait trouver le bon utilisateur" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    it "devrait avoir le bon titre" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.nom)
    end
    it "devrait inclure le nom de l'utilisateur" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.nom)
    end

    it "devrait avoir une image de profil" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  
  end
  
  describe "POST 'create'" do

    describe "echec" do
      before(:each) do
        @attr = { :nom => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end
      it "ne devrait pas creer d'utilisateur" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      it "devrait avoir le bon titre" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Inscription")
      end
      it "devrait rendre la page 'new'" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "succes" do
      before(:each) do
        @attr = { :nom => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end
      it "devrait creer un utilisateur" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      it "devrait identifier l'utilisateur" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
      it "devrait rediriger vers la page d'affichage de l'utilisateur" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end 
      it "devrait avoir un message de bienvenue" do
        post :create, :user => @attr
        flash[:success].should =~ /Bienvenue dans l'Application Exemple/i
      end         
    end
    
  end
  
end