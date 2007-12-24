# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "aln_connections", :primary_key => "aln_connection_id", :force => true do |t|
    t.integer "aln_connection_descendant_id"
    t.string  "aln_connection_descendant_type"
    t.string  "termination_type"
  end

  create_table "aln_network_ids", :force => true do |t|
    t.integer "network_id", :default => 0
  end

  create_table "aln_paths", :primary_key => "aln_path_id", :force => true do |t|
    t.integer "aln_path_descendant_id"
    t.string  "aln_path_descendant_type"
    t.string  "termination_type"
  end

  create_table "aln_resources", :primary_key => "aln_resource_id", :force => true do |t|
    t.integer  "aln_resource_descendant_id"
    t.string   "aln_resource_descendant_type"
    t.integer  "supporter_id"
    t.integer  "support_hierarchy_root_id"
    t.integer  "support_hierarchy_left",       :default => 1
    t.integer  "support_hierarchy_right",      :default => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resource_name"
  end

  create_table "aln_terminations", :primary_key => "aln_termination_id", :force => true do |t|
    t.integer "aln_termination_descendant_id"
    t.string  "aln_termination_descendant_type"
    t.integer "aln_connection_id"
    t.integer "aln_path_id"
    t.integer "termination_supporter_id"
    t.integer "network_id"
    t.integer "layer_id",                        :default => 0
    t.string  "directionality"
    t.string  "direction"
  end

  create_table "application_components", :primary_key => "application_component_id", :force => true do |t|
  end

  create_table "application_mains", :primary_key => "application_main_id", :force => true do |t|
    t.integer "pid"
  end

  create_table "datacenters", :primary_key => "datacenter_id", :force => true do |t|
    t.string "location"
  end

  create_table "ethernet_terminations", :primary_key => "ethernet_termination_id", :force => true do |t|
    t.string "mac_addr"
  end

  create_table "hardware_components", :primary_key => "hardware_component_id", :force => true do |t|
  end

  create_table "inventory_items", :primary_key => "inventory_item_id", :force => true do |t|
    t.integer "inventory_item_descendant_id"
    t.string  "inventory_item_descendant_type"
    t.string  "serial_number"
  end

  create_table "ip_terminations", :primary_key => "ip_termination_id", :force => true do |t|
    t.string "ip_addr"
  end

  create_table "nics", :primary_key => "nic_id", :force => true do |t|
    t.integer "slot"
  end

  create_table "servers", :primary_key => "server_id", :force => true do |t|
    t.string "model"
  end

  create_table "switches", :primary_key => "switch_id", :force => true do |t|
    t.string "model"
  end

  create_table "tcp_socket_terminations", :primary_key => "tcp_socket_termination_id", :force => true do |t|
    t.integer "tcp_port"
  end

end
