
#
# use compass to bootstrap the html5 boilerplate
#
run 'bundle exec compass init rails -r html5-boilerplate -u html5-boilerplate --sass-dir public/stylesheets/sass/ --css-dir public/stylesheets/ --force -q'
file 'app/views/layouts/_header.html.haml',
  open("#{SOURCE}/app/views/layouts/_header.html.haml").read
git :add => "."
git :commit => "-am 'Added HTML5 Layout and templates'"

# patch javascript(-includes)

# remove jquery-1.4.2.min.js since we already got jquery.min.js
run 'rm public/javascripts/jquery-1.4.2.min.js'

# exchange jquery 1.4.2 with 1.4.3
file_str_replace('app/views/layouts/_javascripts.html.haml',
  'google.load("jquery", "1.4.2");',
  'google.load("jquery", "1.4.3");'
)
file_str_replace('app/views/layouts/_javascripts.html.haml',
  '= javascript_include_tag "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"',
  '= javascript_include_tag "http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js"'
)

# add i18n & application js file(s)
file "public/javascripts/application.js", open("#{SOURCE}/public/javascripts/application.js").read
file 'public/javascripts/jquery-ui-i18n.min.js', open('http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/i18n/jquery-ui-i18n.min.js').read

# include formtastic stylesheets
file_str_replace('app/views/layouts/_stylesheets.html.haml',
  "= stylesheet_link_tag 'style', :media => 'all'",
  "= stylesheet_link_tag 'style', 'formtastic', :media => 'all', :cache => 'all'"
)
# include jquery ui
file_inject('app/views/layouts/_javascripts.html.haml',
 'google.load("jquery", "1.4.3");',
 '    google.load("jqueryui", "1.8.6");',
  :after
)
file_str_replace('app/views/layouts/_javascripts.html.haml',
  '= javascript_include_tag "http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js"',
  '= javascript_include_tag "http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js", "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/jquery-ui.min.js", "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/i18n/jquery-ui-i18n.min.js"'
)
# include blackbird
file_inject('app/views/layouts/_javascripts.html.haml',
  '!window.jQuery && document.write(\'#{ escape_javascript(javascript_include_tag "jquery-1.4.3.min") }\')',
  "\n= blackbird_tags.html_safe",
  :after
)
file_str_replace('app/views/layouts/_javascripts.html.haml',
  '!window.jQuery && document.write(\'#{ escape_javascript(javascript_include_tag "jquery-1.4.3.min") }\')',
  '!window.jQuery && document.write(\'#{ escape_javascript(javascript_include_tag "jquery.min", "jquery-ui.min", "jquery-ui-i18n.min", :cache => "jquery_all") }\')'
)
file_str_replace('app/views/layouts/_javascripts.html.haml',
  "= javascript_include_tag 'rails', 'plugins', 'application'",
  "= javascript_include_tag 'rails', 'plugins', 'application', :cache => 'all'"
)
# remove yui profiler and profileviewer
run 'rm -rf public/javascripts/profiling'
file_str_replace('app/views/layouts/_javascripts.html.haml', "-# yui profiler and profileviewer", '')
file_str_replace('app/views/layouts/_javascripts.html.haml', "- if Rails.env == 'development'", '')
file_str_replace('app/views/layouts/_javascripts.html.haml', "  = javascript_include_tag 'profiling/yahoo-profiling.min', 'profiling/config'", '')
# don't overwrite blackbirds log function
file_str_replace('public/javascripts/plugins.js',
  'window.log = function(){',
  'window.clog = function(){'
)
git :add => "."
git :commit => "-am 'Added custom js and js patches'"

# add formtastic.scss
file 'public/stylesheets/sass/formtastic.scss', open("#{SOURCE}/public/stylesheets/formtastic.scss").read
git :add => "."
git :commit => "-am 'added formtastic css'"