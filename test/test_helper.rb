$:.unshift(File.dirname(__FILE__) + '/../lib')
RAILS_ROOT = File.dirname(__FILE__)

require 'rubygems'
require 'test/unit'
require 'active_record'
require 'active_record/fixtures'
require 'active_support/binding_of_caller'
require 'active_support/breakpoint'
require 'yaml'

require "#{File.dirname(__FILE__)}/test_create_model_helper"
require "#{File.dirname(__FILE__)}/../../has_ancestor/lib/has_ancestor"

ActiveRecord::Base.send(:include, PlanB::Has::Ancestor)
require "#{File.dirname(__FILE__)}/../init"

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'mysql'])
load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")
Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

###############################################################################################
class Test::Unit::TestCase #:nodoc:

  def create_fixtures(*table_names)
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end

  #### Turn off transactional fixtures if you're working with MyISAM tables in MySQL
  self.use_transactional_fixtures = true
  
  #### Instantiated fixtures are slow, but give you @david where you otherwise would need people(:david)
  self.use_instantiated_fixtures  = false
  
  #### unit test model
  fixtures :inventory_item, :server, :server_component, :nic, :ip_connection, :ip_termination, 
           :ethernet_termination, :ethernet_connection, :tcp_socket_termination, :tcp_socket_connection, 
           :user, :user_termination, :user_connection, :app_main, :app_main_component
  
  #### load model files
  def setup
    @model = File.open(File.dirname(__FILE__) + '/fixtures/server-1.yml') {|yf| YAML::load(yf)}
  end
  
end