
run 'rm Gemfile'

file 'Gemfile', <<-EOGEMS
source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '>= 3.0.3'
gem 'authlogic', :git => 'git://github.com/NiDi/authlogic.git'
gem 'capistrano', '2.5.19'
gem 'capistrano-ext', '1.2.1'
gem 'config_reader', :git => 'git://github.com/jeanmartin/config_reader-gem.git'
gem 'friendly_id', '>=3.1.3'
gem 'formtastic', '~> 1.1.0'
gem 'compass', '>= 0.10.5'
gem 'html5-boilerplate', :git => 'git://github.com/sporkd/compass-html5-boilerplate.git'
gem 'haml', '>=3.0.18'
gem 'hoe', '>=2.6.1'
gem 'mongrel'
gem 'mysql2'
gem 'hpricot'
gem 'factory_girl_rails'
gem 'faker', :git => 'git://github.com/btelles/faker.git'
gem 'spork'
gem 'rspec-rails', '>= 2.0.1'
gem 'will_paginate', :git => 'http://github.com/mislav/will_paginate.git', :branch => 'rails3'
gem 'whenever'
gem 'SystemTimer'
#{"gem 'bartt-ssl_requirement', :require => 'ssl_requirement'" if @want_ssl}
#{"gem 'jspec'" if @want_jspec}
#{"gem 'paperclip'" if @want_paperclip}
#{"gem 'puret', :git => 'git://github.com/jo/puret.git'" if @want_puret}
#{"gem 'simply_stored'" if @want_couchdb}
#{"gem 'activemerchant', :git => 'git://github.com/Shopify/active_merchant.git'" if @want_am}
#{"gem 'newrelic_rpm', '>=2.13.1'" if @want_newrelic}
#{"gem 'rails-geocoder', :require => 'geocoder'" if @want_geocoding}
#{"gem 'resque'" if @want_resque}
#{"gem 'resque_mailer'" if @want_resque_mailer}

group :development do
  gem 'rails3-generators'
  gem 'haml-rails'
  gem 'jquery-rails'
end

group :test do
  gem 'capybara'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'database_cleaner', :git => 'git://github.com/bmabey/database_cleaner.git'
  gem 'launchy'
  gem 'pickle'
  gem 'rcov'
  gem 'metric_fu'
  gem 'webrat'
  gem 'shoulda'
  gem 'rspec-rails', '>= 2.0.1'
  gem 'ZenTest'
  gem 'autotest-growl'
end
EOGEMS

run 'bundle install'
git :add => "."
git :commit => "-am 'added Gemfile, installed gems'"
