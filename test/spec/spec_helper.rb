############################################################################################
# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= "test"
require "#{File.dirname(__FILE__)}/../rails_root/config/environment.rb"
require "#{RAILS_ROOT}/vendor/plugins/01_rspec_on_rails/lib/spec/rails"
silence_warnings { RAILS_ENV = ENV['RAILS_ENV'] }
ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate")

############################################################################################
# customize
require File.dirname(__FILE__) + '/spec_custom_matchers'
require File.dirname(__FILE__) + '/spec_extensions'

############################################################################################
# add extensions
class Spec::DSL::Behaviour
  def before_eval
    @eval_module.include PlanB::SpecExtensions
    @eval_module.include PlanB::SpecMatchers
  end
end

##############################################################################################
#### global configuration data
Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = File.dirname(__FILE__) + "/../fixtures/"
  config.global_fixtures :inventory_item, :server, :server_component, :nic, :ip_connection, :ip_termination, 
    :ethernet_termination, :ethernet_connection, :tcp_socket_termination, :tcp_socket_connection, 
    :user, :user_termination, :user_connection, :app_main, :app_main_component
  config.model_data = File.open(File.dirname(__FILE__) + '/../fixtures/server-1.yml') {|yf| YAML::load(yf)}
end