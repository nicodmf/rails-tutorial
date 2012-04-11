# encoding: UTF-8
require 'faker'

namespace :db do
  desc "Peupler la base de données avec des échantillons"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Rake::Task['db:migrate'].invoke
    make_users
    make_microposts
    make_relationships
    #Rake::Task['db:test:prepare'].invoke
  end
end

def make_users
  admin = User.create!(:nom => "Nicolas de Marqué",
                       :username => "nico",
                       :email => "nicolas.demarque@gmail.com",
                       :password => "foobar",
                       :password_confirmation => "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    nom  = Faker::Name.name
    username = "example#{n+1}"
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:nom => nom,
                 :username => username,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  50.times do
    User.all(:limit => 6).each do |user|    
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(:content => content)
    end
  end
end

def make_messages
  50.times do
    User.all(:limit => 6).each do |user|    
      content = Faker::Lorem.sentence(5)
      user.messages.create!(:content => content,
                            :receiver => (1..99).to_a.shuffle.first)
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end