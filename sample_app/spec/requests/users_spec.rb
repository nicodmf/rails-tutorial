require 'spec_helper'

describe "Users" do

  describe "une inscription" do

    describe "ratee" do

      it "ne devrait pas creer un nouvel utilisateur" do
        lambda do
          visit signup_path
          fill_in "Nom",          :with => ""
          fill_in "username",     :with => ""
          fill_in "eMail",        :with => ""
          fill_in "password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
    describe "reussie" do
      it "devrait creer un nouvel utilisateur" do
        lambda do
          visit signup_path
          fill_in "Nom",          :with => "Example User"
          fill_in "username",     :with => "Anusername"
          fill_in "eMail",        :with => "user@example.com"
          fill_in "password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Bienvenue")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end
  
    describe "identification/deconnexion" do

    describe "l'echec" do
      it "ne devrait pas identifier l'utilisateur" do
        integration_sign_in(User.create(:email=>"", :password=>""))
        response.should have_selector("div.flash.error", :content => "invalide")
      end
    end

    describe "le succes" do
      it "devrait identifier un utilisateur puis le deconnecter" do
#        user = FactoryGirl.create(:user)
        integration_sign_in(FactoryGirl.create(:user))
        controller.should be_signed_in
        click_link "Deconnexion"
        controller.should_not be_signed_in
      end
    end
  end
  
end