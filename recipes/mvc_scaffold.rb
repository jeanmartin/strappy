
# user & user_sessions
gen 'controller user_sessions'
gen 'scaffold user'
# get rid of the gend templates
Dir.glob('app/views/users/*.erb').each do |file|
  run "rm #{file}"
end
# and the route specs (they are flawed)
run 'rm spec/routing/users_routing_spec.rb'
git :add => "."
git :commit => "-am 'installed user and session management'"

# use our user migration
file Dir.glob('db/migrate/*_create_users.rb').first,
  open("#{SOURCE}/db/migrate/create_users.rb").read
git :add => "."
git :commit => "-am 'installed custom user migration'"

# password resetting
gen 'controller password_resets'

# model
%w( user notifier ).each do |name|
  file "app/models/#{name}.rb",
    open("#{SOURCE}/app/models/#{name}.rb").read
end

# controllers
%w( user_sessions password_resets users ).each do |name|
  file "app/controllers/#{name}_controller.rb",
    open("#{SOURCE}/app/controllers/#{name}_controller.rb").read
end

# views
%w(
  notifier/password_reset_instructions.text.erb
  password_resets/edit.html.haml
  password_resets/new.html.haml
  user_sessions/new.html.haml
  users/_form.html.haml
  users/edit.html.haml
  users/new.html.haml
  users/show.html.haml
).each do |name|
  file "app/views/#{name}", open("#{SOURCE}/app/views/#{name}").read
end
git :add => "."
git :commit => "-am 'installed models, controllers and views'"


# Add ApplicationController
file 'app/controllers/application_controller.rb',
  open("#{SOURCE}/app/controllers/application_controller.rb").read
# Add ApplicationHelper
file 'app/helpers/application_helper.rb',
  open("#{SOURCE}/app/helpers/application_helper.rb").read
git :add => "."
git :commit => "-am 'added ApplicationHelper and -Controller'"

# Remove index.html and add HomeController
git :rm => 'public/index.html'
gen 'controller home'
file 'app/views/home/index.html.haml',
  open("#{SOURCE}/app/views/home/index.html.haml").read
file "app/helpers/home_helper.rb",
  open("#{SOURCE}/app/helpers/home_helper.rb").read
file "spec/controllers/home_controller_spec.rb",
  open("#{SOURCE}/spec/controllers/home_controller_spec.rb").read
git :add => "."
git :commit => "-am 'Removed index.html. Added HomeController'"

# Add Action images
%w(
  add.png
  arrow_up_down.png
  delete.png
  pencil.png
  user_edit.png
).each do |name|
  file "public/images/icons/#{name}",
    open("#{SOURCE}/public/images/icons/#{name}").read
end
git :add => "."
git :commit => "-am 'Added Action images'"

# setup admin section
run "cp app/views/layouts/application.html.haml app/views/layouts/admin.html.haml"
file_str_replace('app/views/layouts/admin.html.haml',
  "= render :partial => 'layouts/header'",
  "= render :partial => 'layouts/admin_header'")
file 'app/views/layouts/_admin_header.html.haml',
  open("#{SOURCE}/app/views/layouts/_admin_header.html.haml").read
%w(
  app/controllers/admin
  app/views/admin/base
  spec/controllers/admin
  app/helpers/admin
).each do |dir|
  run "mkdir -p #{dir}"
end
file "app/views/admin/base/index.html.haml",
  open("#{SOURCE}/app/views/admin/base/index.html.haml").read
file "app/controllers/admin/base_controller.rb",
  open("#{SOURCE}/app/controllers/admin/base_controller.rb").read
file "spec/controllers/admin/base_controller_spec.rb",
  open("#{SOURCE}/spec/controllers/admin/base_controller_spec.rb").read
file "app/helpers/admin/base_helper.rb",
  open("#{SOURCE}/app/helpers/admin/base_helper.rb").read
git :add => "."
git :commit => "-am 'Added admin stubs'"

# Add in the :xhr mime type
file_inject('config/initializers/mime_types.rb',
  '# Be sure to restart your server when you modify this file.',
  'Mime::Type.register_alias "text/html", :xhr',
  :after
)
git :add => "."
git :commit => "-am 'added :xhr mime type'"

# update the readme
run 'rm README'
file 'README.textile', open("#{SOURCE}/README.textile").read
git :add => "."
git :commit => "-am 'Replaced README'"
