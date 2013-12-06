module Common

  def resource_class_name
    if self.class.superclass != ActiveRecord::Base
      return self.class.superclass.name
    end
    return self.class.name
  end

  def resource_id
    self.try(:id)
  end

end
