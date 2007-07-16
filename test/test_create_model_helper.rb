module TestCreateModelHelper

  ###########################################################################################
  #### create model objects
  def create_model_objects(model_name)
  
    @model[model_name].collect do |cfg|
      eval("#{model_name.classify}.new(cfg['attr'])")
    end
    
  end

  ###########################################################################################
  #### create model with support associations
  def create_model_and_support_associations(root, model_name)
  
    #### create models
    models = create_model_objects(model_name)
        
    #### add supported associations
    models.each_with_index do |mod, idx|
      sup = root.fetch_by_attr(@model[model_name][idx]['supported_by_model'].to_sym, :name, 
        @model[model_name][idx]['supported_by_name'])
      sup << mod unless sup.nil? 
    end

  end
  
  ###########################################################################################
  #### build resource hierarchy and save
  def build_support_hierarchy
  
    ##### build server
    srvr = Server.new(@model['server'])
    srvr << create_model_objects('server_component')
    
    create_model_and_support_associations(srvr, 'nic')
    create_model_and_support_associations(srvr, 'app_main')
    create_model_and_support_associations(srvr, 'user')
 
    create_model_and_support_associations(srvr, 'app_main_component')
    create_model_and_support_associations(srvr, 'user_termination')
    create_model_and_support_associations(srvr, 'ethernet_termination')
    
    create_model_and_support_associations(srvr, 'ip_termination')
    create_model_and_support_associations(srvr, 'tcp_socket_termination')
    
    #### save hierarchy
    srvr.save_hierarchy
            
  end  

  ###########################################################################################
  #### build resource hierarchy
  def build_resource_hierarchy
  end  

end