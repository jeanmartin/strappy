require 'faker'

Factory.define :user do |u|
  u.login     Faker::Internet.user_name
  u.email     Faker::Internet.email
  u.password  'password'
  u.password_confirmation 'password'
  u.admin     false
end

Factory.define :admin, :class => User do |u|
  u.login     'admin'
  u.email     Faker::Internet.email
  u.password  'password'
  u.password_confirmation 'password'
  u.admin     true
end