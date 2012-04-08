describe "LayoutLinks" do

  it "devrait trouver une page Accueil a '/'" do
    get '/'
    response.should have_selector('title', :content => "Accueil")
  end

  it "devrait trouver une page Contact at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an A Propos page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "A Propos")
  end

  it "devrait trouver une page Aide a '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Aide")
  end
  
  it "devrait avoir une page d'inscription a '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Inscription")
  end
  
  it "devrait avoir le bon lien sur le layout A Propos" do
    visit root_path
    click_link "A Propos"
    response.should have_selector('title', :content => "A Propos")
  end
  
  it "devrait avoir le bon lien sur le layout Aide" do
    visit root_path
    click_link "Aide"
    response.should have_selector('title', :content => "Aide")
  end
  
  it "devrait avoir le bon lien sur le layout Contact" do
    visit root_path
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
  end
  
  it "devrait avoir le bon lien sur le layout Accueil" do
    visit root_path
    click_link "Accueil"
    response.should have_selector('title', :content => "Accueil")
  end
  
  it "devrait avoir le bon lien sur le layout S'inscrire !" do
    visit root_path
    click_link "S'inscrire !"
    response.should have_selector('title', :content => "Inscription")
  end
  
  describe "quand pas identifie" do
    it "doit avoir un lien de connexion" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "S'identifier")
    end
  end

  describe "quand identifie" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      visit signin_path
      fill_in "email",    :with => @user.email
      fill_in "password", :with => @user.password
      click_button
    end

    it "devrait avoir un lien de deconnxion" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Deconnexion")
    end

    it "devrait avoir un lien vers le profil" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user),
                                         :content => "Profil")
    end
  end
end