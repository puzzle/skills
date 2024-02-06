# frozen_string_literal: true

class Skill::Component < ApplicationViewComponent
  with_collection_parameter :skill
  renders_one :header, "HeaderComponent"

  # def initialize(**args)
  #   super(**args, :skill_iteration)
  # end

  def initialize(skill:, skill_iteration:)
    @skill = skill
    @iteration = skill_iteration
  end

  #   def haml_tag_if(condition, *args, &block)
  #     if condition
  #       puts *args
  #       puts &block
  #
  #       # content_tag(:div, yield, &block.to_sym)
  #       pry
  #       tag.send(*args, &block)
  #     else
  #       yield
  #     end
  #   end
  # end
  # puts *args[0].to_sym
  # puts block.display
  # content_tag(*args[0].to_sym, '', eval(*args[1].to_s))
    def haml_tag_if(condition, wrapper_tag, wrapper_options = {}, &block)
      if condition
        wrapper_content = capture_haml(&block)
        content_tag(wrapper_tag, wrapper_content, wrapper_options)

      else
        capture_haml(&block)
      end
    end
end