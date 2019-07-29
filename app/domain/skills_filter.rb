# frozen_string_literal: true

class SkillsFilter
  attr_reader :entries, :category, :title, :default_set

  def initialize(entries, category, title, default_set)
    @entries = entries
    @category = category
    @title = title
    @default_set = default_set
  end

  def scope
    filtered_entries = filter_by_default_set
    if category.present?
      filtered_entries = filtered_entries.joins(:category)
                                         .where(categories: { parent_id: category })
    end
    if title.present?
      filtered_entries = filtered_entries.where('lower(skills.title) like lower(?)', "%#{title}%")
    end
    filtered_entries
  end

  private

  def filter_by_default_set
    case default_set
    when 'true'
      return entries.where(default_set: true)
    when 'new'
      return entries.where(default_set: nil)
    end
    entries
  end
end
