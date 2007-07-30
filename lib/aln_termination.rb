class AlnTermination < ActiveRecord::Base

   ###############################################################
   #### declare descendant associations and ancestor association
   #### with aln_resource
   ###############################################################
   has_descendants
   has_ancestor :named => :aln_resource   

   ###############################################################
   #### declare terminates association with aln_connection
   ###############################################################
   belongs_to :aln_connection  

   ###############################################################
   #### attribute validators
   ###############################################################
   validates_inclusion_of :directionality, 
                          :in => ['unidirectional', 'bidirectional'],
                          :message => "should be unidirectional or bidirectional",
                          :allow_nil => true

   validates_inclusion_of :direction,
                          :in => ['client', 'server', 'peer'],
                          :message => "should be client, server or peer",
                          :allow_nil => true
end
