
# Capistrano (currently disabled)
# capify!
# file 'config/deploy.rb', open("#{SOURCE}/config/deploy.rb").read
# %w( production staging ).each do |env|
#   file "config/deploy/#{env}.rb", <<-EOC
# set :rails_env, "#{env}"
# set :branch, "#{env}"
# EOC
# end
# git :add => "."
# git :commit => "-am 'added Capistrano config'"

# add cruise profile to cucumber config
file_inject('config/cucumber.yml',
  'std_opts = "--format #{ENV[\'CUCUMBER_FORMAT\'] || \'progress\'} --strict --tags ~@wip"',
  'cruise_opts = "--format pretty --out=#{ENV[\'CC_BUILD_ARTIFACTS\']}/features.txt --format html --out=#{ENV[\'CC_BUILD_ARTIFACTS\']}/features.html"',
  :after
)
file_inject('config/cucumber.yml',
  'rerun: <%= rerun_opts %> --format rerun --out rerun.txt --strict --tags ~@wip',
  'cruise: <%= cruise_opts %>',
  :after
)

# add cruise control task(s)
rakefile('cruise.rake') { open("#{SOURCE}/lib/tasks/cruise.rake").read }

git :add => "."
git :commit => "-am 'Added cruise rake task'"
