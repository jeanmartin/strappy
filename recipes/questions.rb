
puts "\n#{'*' * 80}\n"
puts "Questions 1/3: Project Information"
puts "#{'*' * 80}\n\n"

puts "Your apps shortname is '#{app_name}'"
puts
@app_fullname    = ask("Please enter the full name [#{app_name.capitalize}]:")
@app_fullname    = app_name.capitalize if @app_fullname.blank?
puts "'#{@app_fullname}' it is."
puts


puts "\n#{'*' * 80}\n"
puts "Questions 2/3: plugins & gems"
puts "#{'*' * 80}\n\n"

@want_resque         = yes?("Do you want to use job queuing (resque)?")
@want_resque_mailer  = yes?("Do you want to use mail queuing (resque_mailer)?") if @want_resque
@want_newrelic       = yes?("Do you want New Relic?")
@want_geocoding      = yes?("Do you want geocoding (using geocoder)?")
@want_puret          = yes?("Do you want model translations (using puret)?")
@want_paperclip      = yes?("Do you want file uploads (using paperclip)?")
@want_ssl            = yes?("Do you want SSL (ssl_requirement plugin)?")
@want_am             = yes?("Do you want online payment (using active_merchant)?")
@want_couchdb        = yes?("Do you want to use CouchDB (using simply_stored)?")
@want_jspec          = yes?("Do you want JavaScript tests (using JSpec)?")
puts "\n#{'*' * 80}\n\n"

puts "\n#{'*' * 80}\n"
puts "Question 3/3: database access"
puts "#{'*' * 80}\n\n"
@db_user   = ask("MySQL username [root]:")
@db_user   = 'root' if @db_user.blank?
@db_pw     = ask("MySQL password []:")
puts "\n#{'*' * 80}\n\n"
