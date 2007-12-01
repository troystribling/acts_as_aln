class CreateActsAsAlnModel < ActiveRecord::Migration

  def self.up

    #############################################################################################################
    #### aln infrastructure objects
    create_table :aln_resources, :force => true, :primary_key => :aln_resource_id do |t|
      t.column :aln_resource_descendant_id, :integer
      t.column :aln_resource_descendant_type, :string
      t.column :supporter_id, :integer    
      t.column :support_hierarchy_root_id, :integer
      t.column :support_hierarchy_left, :integer, :default => 1
      t.column :support_hierarchy_right, :integer, :default => 2
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :resource_name, :string
    end
   
    create_table :aln_paths, :force => true, :primary_key => :aln_path_id do |t|
      t.column :aln_path_descendant_id, :integer
      t.column :aln_path_descendant_type, :string
      t.column :termination_type, :string
    end
  
    create_table :aln_connections, :force => true, :primary_key => :aln_connection_id do |t|
      t.column :aln_connection_descendant_id, :integer
      t.column :aln_connection_descendant_type, :string
      t.column :termination_type, :string
    end
  
    create_table :aln_terminations, :force => true, :primary_key => :aln_termination_id do |t|
      t.column :aln_termination_descendant_id, :integer
      t.column :aln_termination_descendant_type, :string
      t.column :aln_connection_id, :integer   
      t.column :aln_path_id, :integer   
      t.column :termination_supporter_id, :integer   
      t.column :network_id, :integer   
      t.column :layer_id, :integer, :default => 0   
      t.column :directionality, :string
      t.column :direction, :string
    end
  
    #############################################################################################################
    #### hardware test objects
    create_table :inventory_items, :force => true, :primary_key => :inventory_item_id do |t|
      t.column :inventory_item_descendant_id, :integer
      t.column :inventory_item_descendant_type, :string
      t.column :serial_number, :string
    end
  
    create_table :datacenters, :force => true, :primary_key => :datacenter_id do |t|
      t.column :location, :string
    end

    create_table :switches, :force => true, :primary_key => :switch_id do |t|
      t.column :model, :string
    end

    create_table :servers, :force => true, :primary_key => :server_id do |t|
      t.column :model, :string
    end
  
    create_table :nics, :force => true, :primary_key => :nic_id do |t|
      t.column :slot, :integer
    end
  
    create_table :hardware_components, :force => true, :primary_key => :hardware_component_id do |t|
    end
  
    #############################################################################################################
    #### application test objects
    create_table :application_mains, :force => true, :primary_key => :application_main_id do |t|
      t.column :pid, :integer
    end
  
    create_table :application_components, :force => true, :primary_key => :application_component_id do |t|
    end
  
    #############################################################################################################
    #### termination point test objects  
    create_table :ethernet_terminations, :force => true, :primary_key => :ethernet_termination_id do |t|
      t.column :mac_addr, :string
    end
  
    create_table :ip_terminations, :force => true, :primary_key => :ip_termination_id do |t|
      t.column :ip_addr, :string
    end
  
    create_table :tcp_socket_terminations, :force => true, :primary_key => :tcp_socket_termination_id do |t|
      t.column :tcp_port, :integer
    end
  
  end
  
  def self.down
  
    drop_table :aln_resources
    drop_table :aln_connections
    drop_table :aln_paths
    drop_table :aln_terminations
    drop_table :inventory_items
    drop_table :switches
    drop_table :datacenters
    drop_table :servers
    drop_table :nics
    drop_table :hardware_components
    drop_table :application_components
    drop_table :application_mains
    drop_table :ip_terminations
    drop_table :tcp_socket_terminations
    drop_table :ethernet_terminations
    
  end
  
end