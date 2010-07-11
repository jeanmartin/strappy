# use this for local installs
SOURCE=ENV['SOURCE'] || 'http://github.com/jeanmartin/strappy/raw/master'

def gen(what)
  run "./script/rails g #{what}"
end

def file_append(file, data)
  log :append, file
  File.open(file, 'a') {|f| f.write(data) }
end

def file_inject(file_name, sentinel, string, before_after=:after)
  log :inject, file_name
  gsub_file file_name, /(#{Regexp.escape(sentinel)})/mi do |match|
    if :after == before_after
      "#{match}\n#{string}"
    else
      "#{string}\n#{match}"
    end
  end
end

def file_str_replace(file_name, sentinel, replacement)
  log :gsub, file_name
  gsub_file file_name, /(#{Regexp.escape(sentinel)})/mi do |match|
    replacement
  end
end

# Git
file_append '.gitignore', open("#{SOURCE}/gitignore").read
git :init
git :add => '.gitignore'
run 'rm -f public/images/rails.png'
run 'cp config/database.yml config/database.template.yml'
git :add => "."
git :commit => "-am 'Initial commit'"

# install Gemfile and gems
run 'rm Gemfile'

file 'Gemfile', <<-EOGEMS
source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '>=3.0.0.beta4'
gem 'authlogic'
gem 'capistrano', '2.5.19'
gem 'capistrano-ext', '1.2.1'
gem 'config_reader', '>=0.0.7'
gem 'friendly_id', '>=3.0.6'
gem "formtastic", :git => "git://github.com/justinfrench/formtastic.git", :branch => "rails3"
gem 'haml', '>=3.0.13'
gem 'hoe', '>=2.6.1'
gem 'mongrel'
gem 'mysql'
gem 'factory_girl_rails'
gem 'test-unit', '>=2.0.9'
gem 'will_paginate', '>=2.3.14'

group :test do
  gem 'capybara'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'pickle'
  gem 'rcov'
  gem 'rspec-rails', '>= 2.0.0.beta.1'
end
EOGEMS

run 'bundle install'
git :add => "."
git :commit => "-am 'Add Gemfile, install gems'"


# CoreExtensions
plugin 'core_extensions',
  :git => 'git://github.com/UnderpantsGnome/core_extensions.git'
git :add => "."
git :commit => "-am 'Added Core Extensions'"

# install strappy rake tasks
rakefile 'strappy.rake', open("#{SOURCE}/lib/tasks/strappy.rake").read

# # install haml rake tasks
# rakefile 'haml.rake', open("#{SOURCE}/lib/tasks/haml.rake").read
# 

# 
# # install rcov rake tasks
# rakefile 'rcov.rake', open("#{SOURCE}/lib/tasks/rcov.rake").read

# RSpec
gen 'rspec:install'
# file 'spec/rcov.opts', open("#{SOURCE}/spec/rcov.opts").read
file_append('spec/spec_helper.rb', open("#{SOURCE}/spec/helpers.rb").read)
git :add => "."
git :commit => "-am 'Added RSpec'"

# Cucumber
gen 'cucumber:install --rspec --capybara'

git :add => "."
git :commit => "-am 'Added Cucumber'"


# 
# SiteConfig
file 'config/site.yml', open("#{SOURCE}/config/site.yml").read
lib 'site_config.rb', open("#{SOURCE}/lib/site_config.rb").read
git :add => "."
git :commit => "-am 'Added SiteConfig'"

# # CC.rb
# rakefile('cruise.rake') { open("#{SOURCE}/lib/tasks/cruise.rake").read }
# git :add => "."
# git :commit => "-am 'Added cruise rake task'"

# Capistrano
capify!
file 'config/deploy.rb', open("#{SOURCE}/config/deploy.rb").read

%w( production staging ).each do |env|
  file "config/deploy/#{env}.rb", <<-EOC
set :rails_env, "#{env}"
set :branch, "#{env}"
EOC

end

inside('config/environments') do
  run 'cp development.rb staging.rb'
end

git :add => "."
git :commit => "-am 'Added Capistrano config'"

run 'echo N\n | haml --rails .'
run 'mkdir -p public/stylesheets/sass'
%w(
  application
  print
  _colors
  _common
  _flash
  _forms
  _grid
  _helpers
  _reset
  _typography
).each do |file|
  file "public/stylesheets/sass/#{file}.sass",
    open("#{SOURCE}/public/stylesheets/sass/#{file}.sass").read
end
git :add => "."
git :commit => "-am 'Added Haml and Sass stylesheets'"


# jRails
plugin 'jrails', :git => 'git://github.com/jeanmartin/jrails.git'
gen 'jrails'
rake('jrails:js:scrub')

initializer 'jrails.rb', <<-EOF
ActionView::Helpers::PrototypeHelper::DISABLE_JQUERY_FORGERY_PROTECTION = true
EOF

git :add => "."
git :commit => "-am 'Added jRails plugin'"


# Bootstrapper

plugin 'bootstrapper', :git => 'git://github.com/jeanmartin/bootstrapper.git'
file 'db/bootstrap.rb', <<-EOF
require File.join(Rails.root, 'spec', 'factories')

Bootstrapper.for :development do |b|
  b.truncate_tables :users

  Factory(:admin)
end

Bootstrapper.for :production do |b|
end

Bootstrapper.for :test do |b|
end

Bootstrapper.for :staging do |b|
end
EOF
git :add => "."
git :commit => "-am 'Added Bootstrapper plugin'"


# additional js files

file 'public/javascripts/jquery.form.js',
  open('http://github.com/malsup/form/raw/master/jquery.form.js').read
file 'public/javascripts/application.js',
  open("#{SOURCE}/public/javascripts/application.js").read

git :add => "."
git :commit => "-am 'Added jQuery form plugin and custom application.js'"

# Blackbird
run 'mkdir -p public/blackbird'
file 'public/blackbird/blackbird.js',
  open('http://blackbirdjs.googlecode.com/svn/trunk/blackbird.js').read
file 'public/blackbird/blackbird.css',
  open('http://blackbirdjs.googlecode.com/svn/trunk/blackbird.css').read
file 'public/blackbird/blackbird.png',
  open('http://blackbirdjs.googlecode.com/svn/trunk/blackbird.png').read

git :add => "."
git :commit => "-am 'Added Blackbird'"


# Formtastic
gen 'formtastic:install'
initializer 'formtastic.rb', <<-CODE
# Set the default text field size when input is a string. Default is 50.
# Formtastic::SemanticFormBuilder.default_text_field_size = 50

# Set the default text area height when input is a text. Default is 20.
# Formtastic::SemanticFormBuilder.default_text_area_height = 5

# Should all fields be considered "required" by default?
# Defaults to true, see ValidationReflection notes below.
# Formtastic::SemanticFormBuilder.all_fields_required_by_default = true

# Should select fields have a blank option/prompt by default?
# Defaults to true.
# Formtastic::SemanticFormBuilder.include_blank_for_select_by_default = true

# Set the string that will be appended to the labels/fieldsets which are required
# It accepts string or procs and the default is a localized version of
# '<abbr title="required">*</abbr>'. In other words, if you configure formtastic.required
# in your locale, it will replace the abbr title properly. But if you don't want to use
# abbr tag, you can simply give a string as below
# Formtastic::SemanticFormBuilder.required_string = "(required)"

# Set the string that will be appended to the labels/fieldsets which are optional
# Defaults to an empty string ("") and also accepts procs (see required_string above)
# Formtastic::SemanticFormBuilder.optional_string = "(optional)"

# Set the way inline errors will be displayed.
# Defaults to :sentence, valid options are :sentence, :list and :none
# Formtastic::SemanticFormBuilder.inline_errors = :sentence

# Set the method to call on label text to transform or format it for human-friendly
# reading when formtastic is used without object. Defaults to :humanize.
# Formtastic::SemanticFormBuilder.label_str_method = :humanize

# Set the array of methods to try calling on parent objects in :select and :radio inputs
# for the text inside each @<option>@ tag or alongside each radio @<input>@. The first method
# that is found on the object will be used.
# Defaults to ["to_label", "display_name", "full_name", "name", "title", "username", "login", "value", "to_s"]
# Formtastic::SemanticFormBuilder.collection_label_methods = [
#   "to_label", "display_name", "full_name", "name", "title", "username", "login", "value", "to_s"]

# Formtastic by default renders inside li tags the input, hints and then
# errors messages. Sometimes you want the hints to be rendered first than
# the input, in the following order: hints, input and errors. You can
# customize it doing just as below:
# Formtastic::SemanticFormBuilder.inline_order = [:input, :hints, :errors]

# Specifies if labels/hints for input fields automatically be looked up using I18n.
# Default value: false. Overridden for specific fields by setting value to true,
# i.e. :label => true, or :hint => true (or opposite depending on initialized value)
Formtastic::SemanticFormBuilder.i18n_lookups_by_default = true

# You can add custom inputs or override parts of Formtastic by subclassing SemanticFormBuilder and
# specifying that class here.  Defaults to SemanticFormBuilder.
# Formtastic::SemanticFormHelper.builder = MyCustomBuilder
CODE


# Setup Authlogic
# rails gets cranky when this isn't included in the config
gen 'model user_session'
run 'rm db/migrate/*_create_user_sessions.rb'

# allow login by login or pass
file 'app/models/user_session.rb', <<-EOF
class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_login_or_email

  # From here: http://github.com/binarylogic/authlogic/issues/issue/101/#comment_142986 
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ] 
  end

end
EOF



# get rid of the gend default layout
run "rm app/views/layouts/application.html.erb"

gen 'controller user_sessions'
gen 'scaffold user'

# get rid of the gend templates
Dir.glob('app/views/users/*.erb').each do |file|
  run "rm #{file}"
end

gen 'controller password_reset'

route <<-EOROUTES
  root :to => 'home#index'

  match 'admin',
    :as => :admin,
    :to => 'admin/base#index'

  match 'login',
    :as => :login,
    :to => 'user_sessions#new'

  match 'logout',
    :as => :logout,
    :to => 'user_sessions#destroy'

  match 'signup',
    :as => :signup,
    :to => 'users#new'

  match 'forgot_password',
    :as => :forgot_password,
    :to => 'password_reset#new'

  resource :account, :controller => "users"
  resource :user_session

  resources :password_reset
  resources :users
EOROUTES

# migrations
file Dir.glob('db/migrate/*_create_users.rb').first,
  open("#{SOURCE}/db/migrate/create_users.rb").read

# models
%w( user notifier ).each do |name|
  file "app/models/#{name}.rb",
    open("#{SOURCE}/app/models/#{name}.rb").read
end

# controllers
%w( user_sessions password_reset users ).each do |name|
  file "app/controllers/#{name}_controller.rb",
    open("#{SOURCE}/app/controllers/#{name}_controller.rb").read
end

# views
%w(
  notifier/password_reset_instructions.erb
  password_reset/edit.html.haml
  password_reset/new.html.haml
  user_sessions/new.html.haml
  users/_form.haml
  users/edit.html.haml
  users/new.html.haml
  users/show.html.haml
).each do |name|
  file "app/views/#{name}", open("#{SOURCE}/app/views/#{name}").read
end

# testing goodies
file_inject('spec/spec_helper.rb',
  "require 'spec/rails'",
  "require 'authlogic/test_case'\n",
  :after
)

# factories
run 'mkdir -p spec/factories'
Dir.glob('spec/factories/*.rb').each do |name|
  file name, open("#{SOURCE}/#{name}").read
end


# specs
run 'mkdir -p spec/fixtures'

%w(
  fixtures/users.yml
  helpers/application_helper_spec.rb
  controllers/password_reset_controller_spec.rb
  controllers/user_sessions_controller_spec.rb
  controllers/users_controller_spec.rb
  models/user_spec.rb
  views/home/index.html.haml_spec.rb
).each do |name|
  file "spec/#{name}", open("#{SOURCE}/spec/#{name}").read
end
git :add => "."
git :commit => "-am 'Added specs'"

# features
%w(
  admin/admin_base.feature
  application/application_base.feature
  home/home.feature
  users/users.feature
  step_definitions/_common_steps.rb
  step_definitions/_custom_web_steps.rb
  step_definitions/user_steps.rb
  support/blueprints.rb
  support/paths.rb
).each do |name|
  file "features/#{name}", open("#{SOURCE}/features/#{name}").read
end

git :add => "."
git :commit => "-am 'Added features'"

route "map.forgot_password '/forgot_password',
  :controller => 'password_reset',
  :action => 'new'"

rake('db:migrate')
git :add => "."
git :commit => "-am 'Added Authlogic'"

# Add ApplicationController
file 'app/controllers/application_controller.rb',
  open("#{SOURCE}/app/controllers/application_controller.rb").read

# Add in the :xhr mime type
file_inject('config/initializers/mime_types.rb',
  '# Be sure to restart your server when you modify this file.',
  'Mime::Type.register_alias "text/html", :xhr',
  :after
)

git :add => "."
git :commit => "-am 'Added ApplicationController'"

# Add ApplicationHelper
file 'app/helpers/application_helper.rb',
  open("#{SOURCE}/app/helpers/application_helper.rb").read
git :add => "."
git :commit => "-am 'Added ApplicationHelper'"

# Add Layout
%w(
  application.html.haml
  _body.html.haml
  _common_headers.html.haml
  _footer.html.haml
  _on_ready.html.haml
).each do |name|
  file "app/views/layouts/#{name}",
    open("#{SOURCE}/app/views/layouts/#{name}").read
end

git :add => "."
git :commit => "-am 'Added Layout and templates'"

# setup admin section
%w(
  app/controllers/admin
  app/views/admin/base
  spec/controllers/admin
  app/helpers/admin
).each do |dir|
  run "mkdir -p #{dir}"
end

file "app/views/layouts/admin.html.haml",
  open("#{SOURCE}/app/views/layouts/admin.html.haml").read
file "app/views/admin/base/index.html.haml",
  open("#{SOURCE}/app/views/admin/base/index.html.haml").read
file "app/controllers/admin/base_controller.rb",
  open("#{SOURCE}/app/controllers/admin/base_controller.rb").read
file "spec/controllers/admin/base_controller_spec.rb",
  open("#{SOURCE}/spec/controllers/admin/base_controller_spec.rb").read
file "app/helpers/admin/base_helper.rb",
  open("#{SOURCE}/app/helpers/admin/base_helper.rb").read

route "map.admin '/admin', :controller => 'admin/base'"

git :add => "."
git :commit => "-am 'Added admin stubs'"

# Remove index.html and add HomeController
git :rm => 'public/index.html'
gen 'controller home'
route "map.root :controller => 'home'"

file 'app/views/home/index.html.haml',
  open("#{SOURCE}/app/views/home/index.html.haml").read

file "app/helpers/home_helper.rb",
  open("#{SOURCE}/app/helpers/home_helper.rb").read

file "spec/views/home/index.html.haml_spec.rb",
  open("#{SOURCE}/spec/views/home/index.html.haml_spec.rb").read

file "spec/controllers/home_controller_spec.rb",
  open("#{SOURCE}/spec/controllers/home_controller_spec.rb").read

git :add => "."
git :commit => "-am 'Removed index.html. Added HomeController'"

# Add ApplicationController
file 'app/controllers/application_controller.rb',
  open("#{SOURCE}/app/controllers/application_controller.rb").read

git :add => "."
git :commit => "-am 'Added ApplicationController'"

# Application Layout
file 'app/views/layouts/application.html.haml',
  open("#{SOURCE}/app/views/layouts/application.html.haml").read

git :add => "."
git :commit => "-am 'Added Layout'"

# update the readme
run 'rm README'
file 'README.textile', open("#{SOURCE}/README.textile").read
git :add => "."
git :commit => "-am 'Replaced README'"

# Add Action images
%w(
  add.png
  arrow_up_down.png
  delete.png
  pencil.png
  user_edit.png
).each do |name|
  file "public/images/#{name}",
    open("#{SOURCE}/public/images/#{name}").read
end

git :add => "."
git :commit => "-am 'Added Action images'"

# cleanup gend tests
run 'rm -rf test'
git :add => "."
git :commit => "-am 'removed gend tests'"

rake 'db:bootstrap'

puts "\n#{'*' * 80}\n\n"
puts "All done. Enjoy."
puts "\n#{'*' * 80}\n\n"
