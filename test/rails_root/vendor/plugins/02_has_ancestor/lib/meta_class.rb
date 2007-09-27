####################################################
class Object

  #### return object meta class
  def meta_class
    class << self
      self
    end
  end

  #### add method to meta class
  def define_meta_class_method(meth_name, &blk)
    meta_class.send(:define_method, meth_name, &blk)
  end
  
end