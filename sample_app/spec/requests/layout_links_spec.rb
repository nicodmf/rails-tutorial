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
  
end