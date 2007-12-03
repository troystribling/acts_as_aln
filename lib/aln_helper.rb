module AlnHelper

  #### find model with specified condition
  def find_by_model_and_condition(condition, model, *args)
    if args.first.eql?(:first) || args.first.eql?(:all)
      if args[1].nil?
        args[1] = {:conditions => condition}
      else
        args[1].include?(:conditions) ? args[1][:conditions] << ' AND ' + condition : args[1][:conditions] = condition
      end
    end
    model.find_by_model(*args)
  end

end