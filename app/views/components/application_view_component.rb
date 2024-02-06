# frozen_string_literal: true

class ApplicationViewComponent < ViewComponentContrib::Base
  def initialize(**args)
    args.each do |name, content|
      instance_variable_set("@#{name}", content)
    end
  end
end
