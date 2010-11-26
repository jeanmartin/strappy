
puts "\n#{'*' * 80}\n\n"
puts "Final Notes:"
puts "\n#{'*' * 80}\n\n"
puts "If you want to use autotest call:"
puts "#> bundle exec autotest"
puts "(or to enable cucumber:)"
puts "#> AUTOFEATURE=true bundle exec autotest"
puts
puts "I recommend the following ~/.autotest file (at least on OS X):"
puts "require 'autotest/growl'

Autotest::Growl::image_dir = 'ampelmaennchen'
Autotest::Growl::clear_terminal = false

Autotest.add_hook(:initialize) {|at|
  %w{.DS_store /db /log /rerun.txt}.each { |e| at.add_exception(e) }
  at.add_exception %r{^\.git}  # ignore Version Control System
  at.add_exception %r{^./tmp}  # ignore temp files, lest autotest will run again, and again...
  #at.clear_mappings         # take out the default (test/test*rb)
  at.add_mapping(%r{^lib/.*\.rb$}) {|f, _|
    Dir['spec/**/*.rb']
  }
  nil
}"
puts "\n#{'*' * 80}\n\n"
puts "All done. Enjoy."
puts "\n#{'*' * 80}\n\n"
