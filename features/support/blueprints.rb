require 'machinist/active_record'
require 'faker'

User.blueprint do
  login { Faker::Internet.user_name }
  email { Faker::Internet.email }
  admin { false }
  password { 'password' }
  password_confirmation { 'password' }
end

User.blueprint(:admin) do
  admin { true }
end
