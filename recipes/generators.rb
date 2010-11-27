
# whenever
run 'wheneverize .'

# jquery-rails
gen 'jquery:install --ui'
git :add => '.'
git :commit => "-am 'installed jQuery (+UI)'"

# SASS folder
run 'mkdir -p public/stylesheets/sass'
git :add => "."
git :commit => "-am 'created SASS directory'"

# JSpec
if @want_jspec
  run 'jspec init --rails'
  git :add => '.'
  git :commit => '-am "installed JSpec"'
end

# simply_stored
if @want_couchdb
  file 'config/couchdb.yml', <<-EOF
development: #{app_name}
test:  #{app_name}_test
production: http://db.server/#{app_name}
EOF
  initializer 'simply_stored.rb', <<-EOF
require 'simply_stored/couch'  
CouchPotato::Config.database_name = '#{app_name}'
EOF
  git :add => '.'
  git :commit => '-am "installed CouchDB support (via simply_stored)"'
end

# friendly_id
gen 'friendly_id'
git :add => "."
git :commit => "-am 'installed friendly_id'"

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
git :add => "."
git :commit => "-am 'installed formtastic'"

# authlogic
gen 'authlogic:session user_session'
run 'rm spec/models/user_session_spec.rb'
run 'rm test/factories/user_sessions.rb'
file_inject('app/models/user_session.rb',
  'class UserSession < Authlogic::Session::Base',
  '  find_by_login_method :find_by_login_or_email

  def persisted?; false; end',
  :after)
git :add => "."
git :commit => "-am 'installed authlogic'"

# RSpec
gen 'rspec:install'
file_append('spec/spec_helper.rb', open("#{SOURCE}/spec/helpers.rb").read)
git :add => "."
git :commit => "-am 'installed RSpec'"

# Cucumber
gen 'cucumber:install --rspec --capybara'
git :add => "."
git :commit => "-am 'installed Cucumber'"

# pickle
gen 'pickle --paths --email --force'
file_inject('features/support/paths.rb',
  "'/'", "
    when /forgot password/
      forgot_password_path
    when 'the login page'
      login_path
    when 'the signup page'
      signup_path
    when 'the admin page'
      admin_path
    when 'the account page'
      account_path
    when 'the account edit page'
      edit_user_path(@user)
",
  :after)
file_inject('features/support/email.rb',
  '# add your own name => email address mappings here',
  '    when /the user/
      @user.try(:email) || @current_user.try(:email)',
  :after
)
git :add => "."
git :commit => "-am 'installed pickle support to cucumber'"