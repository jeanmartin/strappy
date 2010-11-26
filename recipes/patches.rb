
# factory girl
file_inject('config/application.rb',
  '# config.action_view.javascript_expansions[:defaults] = %w(jquery rails)',
  "
    config.generators do |g|
      g.fixture_replacement   :factory_girl, :dir => 'spec/factories'
    end",
  :after)
git :add => "."
git :commit => "-am 'installed factory_girl'"

# enable authlogic in cucumber
file_inject('spec/spec_helper.rb',
  "require 'rspec/rails'",
  "require 'authlogic/test_case'

include Authlogic::TestCase",
  :after)
git :add => "."
git :commit => "-am 'added authlogic to RSpec'"

# disable the capybara_javascript_emulation
# since it's currently broken
file_str_replace('features/support/env.rb',
  "require 'cucumber/rails/capybara_javascript_emulation' # Lets you click links with onclick javascript handlers without using @culerity or @javascript",
  "#require 'cucumber/rails/capybara_javascript_emulation' # Lets you click links with onclick javascript handlers without using @culerity or @javascript"
)
git :add => "."
git :commit => "-am 'disabled the capybara_javascript_emulation'"