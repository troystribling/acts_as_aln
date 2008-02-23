module AlnHelper

  #### find model with specified condition
  def find_by_model_and_condition(condition, model, *args)
    if args.first.eql?(:first) || args.first.eql?(:all)
      if args[1].nil?
        args[1] = {:conditions => condition, :readonly => false}
      else
        if args[1].include?(:conditions) and not args[1][:conditions].blank? 
          args[1][:conditions] << ' AND ' + condition
        else 
         args[1][:conditions] = condition
        end
        args[1].update(:readonly => false)
      end
    end
    model.find_by_model(*args)
  end

end