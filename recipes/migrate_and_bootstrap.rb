
# migrate
rake('db:create')
rake('db:migrate')
git :add => "."
git :commit => "-am 'migrated'"

# bootstrap
rake 'db:bootstrap'
