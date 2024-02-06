# frozen_string_literal: true

class Skill::Component < ApplicationViewComponent
  with_collection_parameter :skill
  renders_one :header, "HeaderComponent"

  class HeaderComponent < ViewComponent::Base
    def call
      content_tag(:table, class: 'table w-50') do
        concat(content_tag(:thead) do
          concat(content_tag(:tr) do
            content_tag :div, content
          end)
        end)

        concat(content_tag(:tbody) do
          entries.each_with_index do |skill, i|
            concat(content_tag(:tr) do
              concat(content_tag(:th, 2, scope: 'row'))
              concat(content_tag(:td, "tesasd"))
              concat(content_tag(:td, skill.people.count))
              concat(content_tag(:td, skill.category.title))
              concat(content_tag(:td, skill.category.parent.title))
              concat(content_tag(:td, skill.default_set))
              concat(content_tag(:td, skill.radar))
            end)
          end
        end)
      end
    end
  end
end