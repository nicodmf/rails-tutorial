# En utilisant le symbole ':user', nous faisons que
# Factory Girl simule un modèle User.

FactoryGirl.define do
  
  factory :user do |user|
    user.nom                   "Michael Hartl"
    user.username              "mhartl"
    user.email                 "mhartl@example.com"
    user.password              "foobar"
    user.password_confirmation "foobar"
  end
  
  factory :micropost do |micropost|
    micropost.content "Foo bar"
    micropost.association :user
  end
  
  sequence :email do |n|
    "person-#{n}@example.com"
  end
  
  sequence :username do |n|
    "person#{n}"
  end
   
end