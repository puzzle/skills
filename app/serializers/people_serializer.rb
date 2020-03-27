# frozen_string_literal: true

class PeopleSerializer < ApplicationSerializer
  attributes :id, :name, :found_in
  def found_in
    if @instance_options[:param].present?
      search_term = @instance_options[:param]
      object.found_in(search_term)
    end
  end
end
