# This assumes you have the metric_fu and kablame plugins installed.
# For kablame I like to modify it to include your stories or features dir as well as the specs.

cc_procede = true

# Set the artifacts dir for development
ENV['CC_BUILD_ARTIFACTS'] ||= File.expand_path("#{Rails.root}/metrics")

# cucumber
begin
  vendored_cucumber_bin = Dir["#{Rails.root}/vendor/{gems,plugins}/cucumber*/bin/cucumber"].first
  $LOAD_PATH.unshift(File.dirname(vendored_cucumber_bin) + '/../lib') unless vendored_cucumber_bin.nil?
  require 'cucumber/rake/task'
rescue LoadError
  # cucumber not installed
  cc_procede = false
end

# rspec
rspec_base = File.expand_path("#{Rails.root}/vendor/plugins/rspec/lib")
$LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base)
require 'rspec/core/rake_task'

require 'bundler'

# metric_fu
begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    config.metrics  = [:churn, :saikuro, :stats, :flog, :flay, :rails_best_practices, :roodi, :reek]
    config.graphs   = [:stats, :flog, :flay, :rails_best_practices, :roodi, :reek]
  end
rescue LoadError
  # metric_fu not installed
  cc_procede = false
end

if cc_procede

  CRUISE_TASKS = %w( cruise:setup_test_env db:drop db:create db:migrate cruise:coverage cruise:cucumber )
  CRUISE_DEV_TASKS = %w( cruise:setup_test_env db:drop db:create db:migrate metrics:all cruise:coverage cruise:cucumber )
  RCOV_THRESHOLD = 50

  desc "Task for cruise Control"
  task :cruise do
    CRUISE_TASKS.each do |t|
      CruiseControl::invoke_rake_task t
    end
  end

  namespace :cruise do
    desc "Run specs and rcov"
    RSpec::Core::RakeTask.new(:coverage) do |t|
      t.spec_opts = ["--format progress -o #{ENV['CC_BUILD_ARTIFACTS']}/specs_profile.log"]
      t.pattern   = 'spec/**/*_spec.rb'
      t.rcov = true
      t.rcov_opts = "--failure-threshold #{RCOV_THRESHOLD} --exclude \"spec/*,gems/*\" --rails -o #{ENV['CC_BUILD_ARTIFACTS']}/specs_rcov"
    end

    task :setup_test_env do
      Rails.env = RAILS_ENV = ENV['RAILS_ENV'] = 'test' # Without this, it will drop your production (or development) database.
      FileUtils.mkdir_p("#{ENV['CC_BUILD_ARTIFACTS']}")
    end
  
    Cucumber::Rake::Task.new({:cucumber => 'db:test:prepare'}, 'Run features for cruise') do |t|
      t.binary = vendored_cucumber_bin
      t.rcov = true
      t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/}
      t.rcov_opts << %[-o "#{ENV['CC_BUILD_ARTIFACTS']}/features_rcov"]
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'cruise'
    end
  
    desc "Run all cruise tasks"
    task :dev do
      FileUtils.mkdir_p("#{ENV['CC_BUILD_ARTIFACTS']}")
    
      CRUISE_DEV_TASKS.each do |t|
        begin
          Rake::Task[t].invoke
        rescue
        end
      end
    
      good_to_go = true
    
      File.open("#{ENV['CC_BUILD_ARTIFACTS']}/index.html", 'w') do |file|
        file.puts <<-HTML
          <html>
            <head>
              <title>Cruise Output</title>
              <style>
                * {font-family: Verdana;}
                div {width:250px;margin:7px auto; padding:4px; border:1px solid grey;}
                div a {display:block;width:250px;padding:4px;text-align:center;color:black;text-decoration:none;}
                div a span {display:block;font-size: 0.7em;margin: 0px;text-align: center;}
                .passed {background-color:green;}
                .passed a,.failed a {color:white;}
                .failed {background-color:red;}
              </style>
            </head>
            <body>
        HTML
      
        puts "\n\n"
      
        # Specs
        specs_output = File.read("#{ENV['CC_BUILD_ARTIFACTS']}/specs_profile.log")
        if specs_output.match(/(?:\d+) examples, (\d+) failures(?:, (?:\d+) pending)?$/)
          num_failures = $1.to_i
        else
          num_failures = 1
        end
      
        if num_failures != 0
          good_to_go = false
          css_class = 'failed'
        else
          css_class = 'passed'
        end
        puts "Specs: #{css_class}"
        file.puts %Q{<div class="#{css_class}"><a href="specs.html">Specs</a></div>}
      
        # Features
        # 12 steps passed
        # 2 steps failed
        # 5 steps skipped
        # 1 steps pending
      
        if File.read("#{ENV['CC_BUILD_ARTIFACTS']}/features.txt") =~ /steps failed/
          good_to_go = false
          css_class = 'failed'
        else
          css_class = 'passed'
        end
      
        puts "Features: #{css_class}"
        file.puts %Q{<div class="#{css_class}"><a href="features.html">Features</a></div>}
        file.puts %Q{<div class="passed"><a href="features_rcov/index.html">Features Coverage</a></div>}
      
        # Coverage
        rcov_output = File.read("#{ENV['CC_BUILD_ARTIFACTS']}/specs_rcov/index.html")
        if rcov_output.match(%r{<tt class='coverage_total'>([\d\.]+)%</tt>})
          percentage = $1.to_f
        else
          percentage = 0.0
        end
      
        if percentage <= RCOV_THRESHOLD
          good_to_go = false
          css_class = 'failed'
        else
          css_class = 'passed'
        end
        puts "Specs Coverage: #{css_class}"
        file.puts %Q{<div class="#{css_class}"><a href="specs_rcov/index.html">Specs Coverage<span>(#{percentage}% &lt; #{RCOV_THRESHOLD}%)</span></a></div>}
      
      
        # Flog & Complexity, etc
        file.puts %Q{<div class=""><a href="output/index.html">Metrics</a></div>}
      
        # End
        file.puts "</body></html>"
      end
    
      sh "open #{ENV['CC_BUILD_ARTIFACTS']}/index.html" unless good_to_go
    end

  end
end