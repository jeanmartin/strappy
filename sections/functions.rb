def gen(what)
  run "./script/rails g #{what}"
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