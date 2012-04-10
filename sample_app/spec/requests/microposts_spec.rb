# encoding: UTF-8
require 'spec_helper'

describe "Microposts" do
  before(:each) do
    user = FactoryGirl.create(:user)
    visit signin_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
  describe "création" do
    describe "échec" do
      it "ne devrait pas créer un nouveau micro-message" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end
    describe "succès" do
      it "devrait créer un nouveau micro-message" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end
  
end
