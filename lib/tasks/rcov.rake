# From http://github.com/jaymcgavren
#   http://gist.github.com/231022
#
# Use rcov:rspec or rcov:cucumber
# to get non-aggregated coverage reports for rspec or cucumber separately

require 'cucumber/rake/task'
require 'spec/rake/spectask'

namespace :rcov do
  Cucumber::Rake::Task.new(:cucumber_run) do |t|
    t.rcov = true
    t.rcov_opts = %w{--rails --text-summary --exclude osx\/objc,gems\/,spec\/,features\/ --aggregate coverage.data}
    t.rcov_opts << %[-o "coverage"]
  end

  Spec::Rake::SpecTask.new(:rspec_run) do |t|
    t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = lambda do
      IO.readlines("#{RAILS_ROOT}/spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
    end
    t.rcov_opts << "--aggregate coverage.data"
  end

  desc "Run both specs and features to generate aggregated coverage"
  task :all do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:rspec_run"].invoke
    Rake::Task["rcov:cucumber_run"].invoke
  end

  desc "Run only rspecs"
  task :rspec do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:rspec_run"].invoke
  end

  desc "Run only cucumber"
  task :cucumber do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:cucumber_run"].invoke
  end
end
