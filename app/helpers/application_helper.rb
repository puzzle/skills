# frozen_string_literal: true

module ApplicationHelper
  def component(name, *args, **kwargs, &block)
    component = name.split('.')[0].to_s.camelize.constantize::Component
    function = name.split('.')[1] || 'new'
    render component.send(function, *args, **kwargs, &block)
  end
end
