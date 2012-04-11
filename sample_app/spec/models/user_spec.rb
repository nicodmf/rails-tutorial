# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  nom                :string(255)
#  email              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#  username           :string(255)
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :nom => "Utilisateur exemple",
      :username => "utilisateur_exemple",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end  
  it "devrait creer une nouvelle instance dotee des attributs valides" do
    User.create!(@attr)
  end
  it "exige un nom" do
    bad_guy = User.new(@attr.merge(:nom => ""))
    bad_guy.should_not be_valid
  end  
  it "devrait rejeter les noms trop longs" do
    long_nom = "a" * 51
    long_nom_user = User.new(@attr.merge(:nom => long_nom))
    long_nom_user.should_not be_valid
  end  
  it "devrait accepter une adresse email valide" do
    adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    adresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  it "devrait rejeter une adresse email invalide" do
    adresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    adresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end  
  it "devrait rejeter un email double" do
    # Place un utilisateur avec un email donné dans la BD.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end  
  it "devrait rejeter une adresse email invalide jusqu'a la casse" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "password validations" do
    it "devrait exiger un mot de passe" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
    it "devrait exiger une confirmation du mot de passe qui correspond" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    it "devrait rejeter les mots de passe (trop) courts" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    it "devrait rejeter les (trop) longs mots de passe" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end
    it "devrait avoir un attribut mot de passe crypte" do
      @user.should respond_to(:encrypted_password)
    end
    it "devrait definir le mot de passe crypte" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "Methode has_password?" do
      it "doit retourner true si les mots de passe coincident" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "doit retourner false si les mots de passe divergent" do
        @user.has_password?("invalide").should be_false
      end 
    end
    
    describe "authenticate method" do
      it "devrait retourner nul en cas d'inequation entre email/mot de passe" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      it "devrait retourner nil quand un email ne correspond a aucun utilisateur" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      it "devrait retourner l'utilisateur si email/mot de passe correspondent" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
    
  end
  
  describe "Attribut admin" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "devrait confirmer l'existence de `admin`" do
      @user.should respond_to(:admin)
    end
    it "ne devrait pas etre un administrateur par defaut" do
      @user.should_not be_admin
    end
    it "devrait pouvoir devenir un administrateur" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
  describe "les associations au micro-message" do
    before(:each) do
      @user = User.create(@attr)
      @mp1 = FactoryGirl.create(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = FactoryGirl.create(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    it "devrait avoir un attribut 'microposts'" do
      @user.should respond_to(:microposts)
    end
    it "devrait avoir les bons micro-messags dans le bon ordre" do
      @user.microposts.should == [@mp2, @mp1]
    end
    it "devrait détruire les micro-messages associés" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end
    
    describe "état de l'alimentation" do
      it "devrait avoir une alimentation" do
        @user.should respond_to(:feed)
      end
      it "devrait inclure les micro-messages de l'utilisateur" do
        @user.feed.should include(@mp1)
        @user.feed.should include(@mp2)
      end
      it "ne devrait pas inclure les micro-messages d'un utilisateur différent" do
        mp3 = FactoryGirl.create(:micropost, :user => FactoryGirl.create(:user, :email => FactoryGirl.generate(:email)))
        @user.feed.should_not include(mp3)
      end
      it "devrait inclure les micro-messages des utilisateurs suivis" do
        followed = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
        mp3 = FactoryGirl.create(:micropost, :user => followed)
        @user.follow!(followed)
        @user.feed.should include(mp3)
      end
    end
    
    describe "incluant un état de l'alimentation" do
      it "devrait avoir une methode `feed`" do
        @user.should respond_to(:feed)
      end
      it "devrait inclure les micro-messages de l'utilisateur" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end
      it "ne devrait pas inclure les micro-messages d'un autre utilisateur" do
        mp3 = FactoryGirl.create(:micropost, :user => FactoryGirl.create(:user, :email => FactoryGirl.generate(:email)))
        @user.feed.include?(mp3).should be_false
      end
    end
    
  end
  
  describe "relationships" do
    before(:each) do
      @user = User.create!(@attr)
      @followed = FactoryGirl.create(:user)
    end
    it "devrait posséder une méthode `relationships`" do
      @user.should respond_to(:relationships)
    end
    it "devrait posséder une méthode `following" do
      @user.should respond_to(:following)
    end
    it "devrait avoir une méthode following?" do
      @user.should respond_to(:following?)
    end
    it "devrait avoir une méthode follow!" do
      @user.should respond_to(:follow!)
    end
    it "devrait suivre un autre utilisateur" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end
    it "devrait inclure l'utilisateur suivi dans la liste following" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end
    it "devrait avoir une méthode unfollow!" do
      @followed.should respond_to(:unfollow!)
    end
    it "devrait arrêter de suivre un utilisateur" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end    
    it "devrait avoir un méthode reverse_relationship" do
      @user.should respond_to(:reverse_relationships)
    end
    it "devrait avoir une méthode followers" do
      @user.should respond_to(:followers)
    end
    it "devrait inclure le lecteur dans le tableau des lecteurs" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end
    it "devrait détruire les micro-messages associés" do
      user_id = @user.id
      @user.destroy
      Relationship.find_by_follower_id(user_id).should be_nil
      Relationship.find_by_followed_id(user_id).should be_nil
    end    
  end  
  
end
