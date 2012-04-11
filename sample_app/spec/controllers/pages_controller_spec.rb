# encoding: UTF-8
require 'spec_helper'
require 'faker'

describe PagesController do
  render_views

  describe "GET 'home'" do
    it "devrait reussir" do
      get 'home'
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get 'home'
      response.should have_selector("title", :content => "Accueil")
    end
    
    describe "pour un utilisateur identifie" do
      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        @attr = { :content => Faker::Lorem.sentence(5) }    
        @count = 50
        @count.times do
          @micropost = @user.microposts.create(@attr)
        end
        other_user = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email), :username => FactoryGirl.generate(:username))
        other_user.follow!(@user)
      end
      it "devrait montrer le bon nombre de messages" do
        get 'home'
        response.should have_selector("span", "class"=>"microposts", :content => @count.to_s())
      end
      it "devrait paginer les messages" do
        get 'home'
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "Next")
      end
      it "devrait avoir le bon compte d'auteurs et de lecteurs" do
        get :home
        #puts following_user_path(@user);
        response.should have_selector("a", :href => following_user_path(@user), :content => "0 auteur suivi")
        response.should have_selector("a", :href => followers_user_path(@user), :content => "1 lecteur")
      end
    end
    
    describe "quand pas identifié" do
      before(:each) do
        get :home
      end
      it "devrait réussir" do
        response.should be_success
      end
      it "devrait avoir le bon titre" do
        response.should have_selector("title", :content => "#{@base_titre} | Accueil")
      end
    end    
    
  end

  describe "GET 'contact'" do
    it "devrait reussir" do
      get 'contact'
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get 'contact'
      response.should have_selector("title", :content => "Contact")
    end
  end

  describe "GET 'about'" do
    it "devrait reussir" do
      get 'about'
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get 'about'
      response.should have_selector("title", :content => "A Propos")
    end
  end
  
  describe "GET 'help'" do
    it "devrait reussir" do
      get 'help'
      response.should be_success
    end
    it "devrait avoir le bon titre" do
      get 'help'
      response.should have_selector("title", :content => "Aide")
    end
  end
end