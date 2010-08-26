Factory.define :admin, :class => User do |u|
  u.login     'admin'
  u.email     'admin@example.com'
  u.password  'changeme'
  u.password_confirmation 'changeme'
  u.admin     true
end