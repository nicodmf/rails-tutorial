# encoding: utf-8
# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = { :content => "Contenu du message" }
  end

  it "devrait créer instance de micro-message avec bons attributs" do
    @user.microposts.create!(@attr)
  end

  describe "associations avec l'utilisateur" do

    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end
    it "devrait avoir un attribut user" do
      @micropost.should respond_to(:user)
    end
    it "devrait avoir le bon utilisateur associé" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end
  
  describe "validations" do
    it "requiert un identifiant d'utilisateur" do
      Micropost.new(@attr).should_not be_valid
    end
    it "requiert un contenu non vide" do
      @user.microposts.build(:content => "  ").should_not be_valid
    end
    it "derait rejeter un contenu trop long" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end
  end
  
end
