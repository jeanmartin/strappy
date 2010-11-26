# use this for local installs
SOURCE=ENV['SOURCE'] || 'https://github.com/jeanmartin/strappy/raw/master'

# I'm lazy
def gen(what)
  generate what
end

def file_append(file, data)
  log :append, file
  File.open(file, 'a') {|f| f.write(data) }
end

def file_inject(file_name, sentinel, string, before_after=:after)
  log :inject, file_name
  gsub_file file_name, /(#{Regexp.escape(sentinel)})/mi do |match|
    if :after == before_after
      "#{match}\n#{string}"
    else
      "#{string}\n#{match}"
    end
  end
end

def file_str_replace(file_name, sentinel, replacement)
  log :gsub, file_name
  gsub_file file_name, /(#{Regexp.escape(sentinel)})/mi do |match|
    replacement
  end
end


puts
puts "\n#{'*' * 80}\n"
puts "Applying template: #{SOURCE}/base.rb"
puts "#{'*' * 80}\n\n"

[
  :questions,
  :initial_setup,
  :database_config,
  :gems,
  :plugins,
  :generators,
  :patches,
  :html5boilerplate,
  :routes
  :mvc_scaffold,
  :custom_files_and_patches,
  :ci_and_deployment,
  :cleanup,
  :migrate_and_bootstrap,
  :bye
].each do |recipe|
  apply("#{SOURCE}/recipes/#{recipe}.rb")
end
