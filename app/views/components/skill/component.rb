# frozen_string_literal: true

class Skill::Component < ApplicationViewComponent
  with_collection_parameter :skill
  def initialize(skill:)
    @skill = skill
  end
end
