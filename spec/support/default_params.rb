require 'active_support/concern'

module DefaultParams
  extend ActiveSupport::Concern

  included do
    let(:default_params) {{locale: I18n.locale}}
    prepend RequestHelpersCustomized
  end

  module RequestHelpersCustomized
    l = lambda do |path, **kwargs|
      if default_params
        kwargs[:params] ||= {}
        default_params.each do |key, value|
          kwargs[:params][key] ||= value
        end
      end
      super(path, params: kwargs[:params])
    end
    %w(get post patch put delete).each do |method|
      define_method(method, l)
    end
  end
end
