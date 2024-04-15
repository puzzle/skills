# frozen_string_literal: true

module GenerifyHelper
  def name_of_obj(entry)
    entry.class.to_s.split('::').first.underscore
  end

  def class_of(entry)
    name_of_obj(entry).classify.constantize
  end
end
