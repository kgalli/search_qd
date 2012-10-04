require 'yaml'
require 'search_qd'

config = YAML.load_file File.expand_path(File.dirname(__FILE__)+ '/db_config.yml')
ActiveRecord::Base.establish_connection config
