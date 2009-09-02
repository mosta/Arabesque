require 'yaml'
require 'berkeleydb'
require 'queues_manager'

@@config = YAML.load_file("config/config.yml") rescue nil || {}
@@queues_manager = Arabesque::QueuesManager.new(File.expand_path(File.dirname(__FILE__)) + "/" + @@config["data_folder"])
