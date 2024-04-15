# frozen_string_literal: true

module GenerifyHelper
  def name_of_obj(obj)
    obj.model_name.element
  end
end
