# frozen_string_literal: true

module SelectHelper
  def select_when_availabale(obj)
    selected = obj.present? ? polymorphic_path(obj) : ''
    prompt = obj.nil?
    { selected: selected, prompt: prompt, disabled: '' }
  end

  def add_default_option(collection, option = {})
    collection.unshift([option[:text], option[:value], option])
  end

  def skills_dropdown_options
    skills = Skill.list.map { |s| [s.title, s.id, { 'data-category-id': s.category.id }] }
    add_default_option(skills, { 'data-placeholder': true })
  end

  def model_path_or_nil(model)
    polymorphic_path(model) if model
  end
end
