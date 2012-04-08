require 'spec_helper'

describe "Users" do

  describe "une inscription" do

    describe "ratee" do

      it "ne devrait pas creer un nouvel utilisateur" do
        lambda do
          visit signup_path
          fill_in "Nom",          :with => ""
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
          fill_in "Nom", :with => "Example User"
          fill_in "eMail", :with => "user@example.com"
          fill_in "password", :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Bienvenue")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end
end