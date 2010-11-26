
run 'rm -rf test'

# clear helper specs
inside('spec/helpers') do
  run 'rm -rf *'
end

# clear view specs
inside('spec/views') do
  run 'rm -rf *'
end

# clear request specs
inside('spec/requests') do
  run 'rm -rf *'
end

# remove user_session_spec
run 'rm spec/models/user_session_spec.rb'

git :add => '.'
git :commit => '-am "cleanup"'

run 'mkdir -p spec/fixtures'
%w(
  fixtures/users.yml
  helpers/application_helper_spec.rb
  controllers/password_resets_controller_spec.rb
  controllers/user_sessions_controller_spec.rb
  controllers/users_controller_spec.rb
  models/user_spec.rb
).each do |name|
  file "spec/#{name}", open("#{SOURCE}/spec/#{name}").read
end
git :add => '.'
git :commit => "-am 'added specs'"