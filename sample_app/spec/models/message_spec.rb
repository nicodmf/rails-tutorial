# encoding: utf-8
# == Schema Information
#
# Table name: messages
#
#  id          :integer         not null, primary key
#  content     :string(255)
#  user_id     :integer
#  receiver_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Message do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @receiver = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email), :username => FactoryGirl.generate(:username))
    @attr = { :content => "Contenu du message",  :receiver=>@receiver}
  end

  it "devrait créer instance de message avec bons attributs" do
    @user.messages.create!(@attr)
  end

  describe "associations avec l'utilisateur" do

    before(:each) do
      @message = @user.messages.create(@attr)
    end
    it "devrait avoir un attribut user" do
      @message.should respond_to(:user)
    end
    it "devrait avoir le bon utilisateur associé" do
      @message.user_id.should == @user.id
      @message.user.should == @user
    end
  end
  
  describe "validations" do
    it "requiert un identifiant d'utilisateur" do
      Message.new(@attr).should_not be_valid
    end
    it "requiert un contenu non vide" do
      @user.messages.build(:content => "  ").should_not be_valid
    end
    it "derait rejeter un contenu trop long" do
      @user.messages.build(:content => "a" * 141).should_not be_valid
    end
  end
  
  describe "recu" do
    before(:each) do
      @message = @user.messages.create(@attr)
    end
    it "devrait être capable de connaitre les messages d'un destinataire" do
      Message.should respond_to(:received_by)
    end
    it "devrait connaitres les messages d'un destinaire" do
      Message.received_by(@receiver).should include(@message)
    end
  end
  
end
