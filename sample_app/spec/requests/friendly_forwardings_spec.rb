require 'spec_helper'

describe "FriendlyForwardings" do

  it "devrait rediriger vers la page voulue apres identification" do
    user = FactoryGirl.create(:user)
    visit edit_user_path(user)
    # Le test suit automatiquement la redirection vers la page d'identification.
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
    # Le test suit à nouveau la redirection, cette fois vers users/edit.
    response.should render_template('users/edit')
  end
end