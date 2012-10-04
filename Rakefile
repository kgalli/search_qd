require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'active_record'

RSpec::Core::RakeTask.new(:spec)

task :default do
  Rake::Task["db:setup"].invoke      
  Rake::Task[:spec].invoke
end

namespace :db do
  desc 'Create and configure test database'
  task :setup do
    spec_dir = File.expand_path(File.dirname(__FILE__) + '/spec')
    db_config = "#{spec_dir}/db_config.yml"

    unless File.exists?(db_config)
      STDOUT.puts "Database configuration file #{db_config} could not been found."
    else
      STDOUT.puts "Try running migrations"
      Rake::Task["db:drop"].invoke
      Rake::Task["db:migrate"].invoke
    end
  end

  desc 'Run migrations for test database'
  task :migrate do
    spec_dir = File.expand_path(File.dirname(__FILE__) + '/spec')
    db_config = "#{spec_dir}/db_config.yml"

    ActiveRecord::Base.establish_connection(YAML.load_file(db_config))
    ActiveRecord::Migration.instance_eval do
      create_table :blogs do |t|
        t.string :title
        t.text :content
        t.string :user_name
      end
    end
  end

  desc 'Drop tables from test database'
  task :drop do
    spec_dir = File.expand_path(File.dirname(__FILE__) + '/spec')
    db_config = "#{spec_dir}/db_config.yml"

    ActiveRecord::Base.establish_connection(YAML.load_file(db_config))
    ActiveRecord::Migration.instance_eval do
      drop_table :blogs if self.table_exists?(:blogs) 
    end
  end
end
