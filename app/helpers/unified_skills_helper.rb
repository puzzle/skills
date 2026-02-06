module UnifiedSkillsHelper
  include ParamConverters

  def old_skill1_select_options
    options_for_select(skills_for_dropdown, selected: old_skill_id1)
  end

  def old_skill2_select_options
    options_for_select(skills_for_dropdown, selected: old_skill_id2)
  end

  def old_skill_id1
    entry.old_skill_id1
  end

  def old_skill_id2
    entry.old_skill_id2
  end

  def skill_value(key)
    entry.new_skill&.dig(key)
  end

  def category_map_for_dropdown
    Category.all_children.sort_by { |category| category.parent&.title }
            .map { |category| [category.name_with_parent, category.id] }
  end

  private

  def skills_for_dropdown
    Skill.all
         .sort_by(&:title)
         .map { |skill| [skill.title, skill.id] }
         .unshift([ta('please_select'), nil])
  end
end
