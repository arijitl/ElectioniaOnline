# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])

#   Mayor.create(name: 'Emanuel', city: cities.first)

r1 = Role.create!(:name=>"admin")
r2 = Role.create!(:name=>"other_user")


User.create!(:email => "admin123@ptotem.com", :password => "p20o20e13", :password_confirmation => "p20o20e13")

User.create!(:email => "perseus2@hotmail.com", :password => "rachanaa", :password_confirmation => "rachanaa",:provider => "facebook",:uid => "507245646",:name=>"Perseus Vazifdar",:role_id => r1.id,:is_admin => true )
User.create!(:email => "neil08.panchal@gmail.com", :password => ")^ptKJtp^(NN", :password_confirmation => ")^ptKJtp^(NN",:provider => "facebook",:name=>"Nilesh",:role_id => r1.id,:is_admin => false )