
# Blackbird
run 'mkdir -p public/blackbird'
file 'public/blackbird/blackbird.js',
  open('http://blackbirdjs.googlecode.com/svn/trunk/blackbird.js').read
file 'public/blackbird/blackbird.css',
  open('http://blackbirdjs.googlecode.com/svn/trunk/blackbird.css').read
file 'public/blackbird/blackbird.png',
  open('http://blackbirdjs.googlecode.com/svn/trunk/blackbird.png').read
git :add => "."
git :commit => "-am 'installed Blackbird'"

# strappy rake tasks
rakefile 'strappy.rake', open("#{SOURCE}/lib/tasks/strappy.rake").read
git :add => "."
git :commit => "-am 'Added strappy rake file'"

# SiteConfig
file 'config/site.yml', <<-EOF
defaults:
  site_url: http://localhost:3000/
  host_name: #{app_name}.com
  mail_from: noreply@#{app_name}.com
  site_name: #{app_fullname}
  admin_email: admin@#{app_name}.com
  blackbird: true

production:
  site_url: http://#{app_name}.com
  blackbird: false

test:
  blackbird: false

EOF
initializer 'site_config.rb', open("#{SOURCE}/lib/site_config.rb").read
git :add => "."
git :commit => "-am 'added SiteConfig'"

# factories
run 'mkdir -p spec/factories'
%w( users ).each do |name|
  file "spec/factories/#{name}.rb", open("#{SOURCE}/spec/factories/#{name}.rb").read
end
git :add => "."
git :commit => "-am 'added factories'"

# features
%w(
  admin/admin_base.feature
  application/application_base.feature
  home/home.feature
  users/users.feature
  step_definitions/_common_steps.rb
  step_definitions/_custom_web_steps.rb
  step_definitions/user_steps.rb
).each do |name|
  file "features/#{name}", open("#{SOURCE}/features/#{name}").read
end
git :add => "."
git :commit => "-am 'added features'"

# spork
run 'spork --bootstrap'
git :add => "."
git :commit => "-am 'Bootstrapped spork'"