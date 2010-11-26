
file 'config/database.yml', 
%Q{
development:
  adapter: mysql2
  database: #{app_name}_development
  username: #{@db_user}
  password: #{@db_pw}
  host: localhost
  encoding: utf8
 
test:
  adapter: mysql2
  database: #{app_name}_test
  username: #{@db_user}
  password: #{@db_pw}
  host: localhost
  encoding: utf8
 
staging:
  adapter: mysql2
  database: #{app_name}_staging
  username: #{app_name}
  password:
  host: localhost
  encoding: utf8
  socket: /var/lib/mysql/mysql.sock
 
production:
  adapter: mysql2
  database: #{app_name}
  username: #{app_name}
  password:
  host: localhost
  encoding: utf8
  socket: /var/lib/mysql/mysql.sock
}
