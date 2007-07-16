ActiveRecord::Schema.define(:version => 1) do

  #############################################################################################################
  #### aln infrastructre objects
  create_table :aln_things, :force => true, :primary_key => :aln_thing_id do |t|
    t.column :aln_support_hierarchy_descendant_id, :integer
    t.column :aln_support_hierarchy_descendant_type, :string
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
    t.column :name, :string
    t.column :supporter_id, :integer    
    t.column :supported_type, :string    
  end
 
  create_table :aln_resources, :force => true, :primary_key => :aln_resource_id do |t|
    t.column :aln_resource_descendant_id, :integer
    t.column :aln_resource_descendant_type, :string
  end

  create_table :aln_connections, :force => true, :primary_key => :aln_connection_id do |t|
    t.column :aln_connection_descendant_id, :integer
    t.column :aln_connection_descendant_type, :string
  end

  create_table :aln_terminations, :force => true, :primary_key => :aln_termination_id do |t|
    t.column :aln_termination_descendant_id, :integer
    t.column :aln_termination_descendant_type, :string
    t.column :aln_connection_id, :integer    
    t.column :direction, :string
  end

  #############################################################################################################
  #### server unit test objects
  create_table :inventory_items, :force => true, :primary_key => :inventory_item_id do |t|
    t.column :inventory_item_descendant_id, :integer
    t.column :inventory_item_descendant_type, :string
    t.column :serial_number, :string
  end

  create_table :servers, :force => true, :primary_key => :server_id do |t|
    t.column :model, :string
  end

  create_table :server_components, :force => true, :primary_key => :server_component_id do |t|
  end

  #############################################################################################################
  #### application unit test objects
  create_table :app_mains, :force => true, :primary_key => :process_id do |t|
    t.column :pid, :integer
  end

  create_table :app_main_components, :force => true, :primary_key => :process_component_id do |t|
  end

  #############################################################################################################
  #### nic unit test objects
  create_table :nics, :force => true, :primary_key => :nic_id do |t|
    t.column :slot, :integer
  end

  create_table :ip_terminations, :force => true, :primary_key => :ip_termination_id do |t|
    t.column :ip_addr, :string
  end

  create_table :ip_connections, :force => true, :primary_key => :ip_connection_id do |t|
  end

  create_table :tcp_socket_terminations, :force => true, :primary_key => :ip_termination_id do |t|
  end

  create_table :tcp_socket_connections, :force => true, :primary_key => :ethernet_connection_id do |t|
    t.column :port, :integer
    t.column :foreign_addr, :string
  end
    
  create_table :ethernet_terminations, :force => true, :primary_key => :ethernet_termination_id do |t|
    t.column :mac_addr, :string
  end

  create_table :ethernet_connections, :force => true, :primary_key => :ethernet_connection_id do |t|
  end

  #############################################################################################################
  #### user unit test objects
  create_table :users, :force => true, :primary_key => :user_id do |t|
    t.column :uid, :integer
  end
    
  create_table :user_terminations, :force => true, :primary_key => :user_termination_id do |t|
  end

  create_table :user_connections, :force => true, :primary_key => :user_connection_id do |t|
  end
    
end
