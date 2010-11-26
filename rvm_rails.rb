rvm_lib_path = "#{`echo $rvm_path`.strip}/lib"
$LOAD_PATH.unshift(rvm_lib_path) unless $LOAD_PATH.include?(rvm_lib_path)
require 'rvm'

def yes?(question)
  answer = ask(question).downcase
  answer == "y" || answer == "yes"
end

def ask(question)
  print "#{question} "
  STDIN.gets.strip
end

app_name = ARGV[0] || ask("Tell me the shortname of your application (will be used in 'rails new <app_name>'):")
rvm_ruby = ARGV[1]

unless rvm_ruby
  rvm_ruby = `rvm-prompt i v p`.strip
  puts "You are currently using: #{rvm_ruby}"
  unless yes?("Do you want this one?")
    rvm_ruby = ask("Please enter the ruby you want then:")
  end
end

@env = RVM::Environment.new(rvm_ruby)
ENV['RVM_RUBY'] = rvm_ruby

#raise @env.info.inspect

puts "Creating gemset #{app_name} in #{rvm_ruby}"
@env.gemset_create(app_name)
puts "Now using gemset #{app_name}"
#@env.gemset_use(app_name)
@env = RVM::Environment.new("#{rvm_ruby}@#{app_name}")

puts "Installing gem: bundler"
puts "Successfully installed bundler" if @env.system("gem", "install", "bundler")
puts "Installing gem: rails"
puts "Successfully installed rails" if @env.system("gem", "install", "rails")

#template_file = File.join(File.expand_path(File.dirname(__FILE__)), 'templater.rb')
template_file = '~/rails/plugins/strappy/template.rb'
system("SOURCE=~/rails/plugins/strappy rvm #{rvm_ruby}@#{app_name} exec rails new #{app_name} -d mysql -m #{template_file}")
#template_file = 'https://github.com/jeanmartin/strappy/raw/master/template.rb'
#system("rvm #{rvm_ruby}@#{app_name} exec rails new #{app_name} -d mysql -m #{template_file}")
