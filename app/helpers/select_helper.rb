# frozen_string_literal: true

module SelectHelper
  def select_when_available(obj)
    selected = obj || ''
    prompt = selected.blank?
    { selected: selected, prompt: prompt, disabled: '' }
  end

  def add_default_option(collection, option = {})
    collection.unshift([option[:text], option[:value], option])
  end

  def skills_dropdown_options
    skills = Skill.list.index_by(&:id)

    options = Skill.for_select.map do |title, id|
      [title, id, { 'data-category-id': skills[id]&.category&.id }]
    end

    add_default_option(options, { 'data-placeholder': true })
  end

  def model_path_or_nil(model)
    polymorphic_path(model) if model
  end
end
