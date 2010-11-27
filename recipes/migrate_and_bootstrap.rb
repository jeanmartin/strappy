
# migrate
rake('db:create')
rake('db:migrate')
git :add => "."
git :commit => "-am 'migrated'"

# hoptoad (needs database)
gen "hoptoad --api-key #{@hoptoad_key}" if @want_hoptoad

# bootstrap
rake 'db:bootstrap'
