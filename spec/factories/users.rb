Factory.define :admin do |u|
  u.login     'admin'
  u.email     'admin@example.com'
  u.password  'changeme'
  u.admin     true
end