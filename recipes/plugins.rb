
# dynamic_form
plugin 'dynamic_form', :git => 'git://github.com/rails/dynamic_form.git'
git :add => "."
git :commit => "-am 'installed plugin: dynamic_form'"

# Bootstrapper
plugin 'bootstrapper', :git => 'git://github.com/jeanmartin/bootstrapper.git'
file 'db/bootstrap.rb', <<-EOF
Bootstrapper.for :development do |b|
  b.truncate_tables :slugs
  b.run :dev_users
end

Bootstrapper.for :production do |b|
end

Bootstrapper.for :test do |b|
end

Bootstrapper.for :staging do |b|
end


Bootstrapper.for :dev_users do |b|
  b.truncate_tables :users
  5.times { Factory(:user) }
  Factory(:admin)
end
EOF
git :add => "."
git :commit => "-am 'installed plugin: bootstrapper'"
