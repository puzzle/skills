class UnifiedSkillsController < CrudController
  self.permitted_attrs = [:old_skill_id1, :old_skill_id2, { skill:
                              [:id, :title, :radar, :portfolio, :default_set, :category_id] }]
  # rubocop:disable Metrics
  def create
    ActiveRecord::Base.transaction do
      params.permit!
      validate!

      new_skill = Skill.create!(new_skill_values)
      old_skill1 = Skill.find(old_skill_id1)
      old_skill2 = Skill.find(old_skill_id2)
      UnifiedSkill.create!(skill1_attrs: old_skill1.attributes, skill2_attrs: old_skill2.attributes,
                           unified_skill_attrs: new_skill.attributes)
      PeopleSkill.where(skill_id: [old_skill_id1, old_skill_id2]).update!(skill_id: new_skill.id)
      old_skill1.delete
      old_skill2.delete
    end
  end
  # rubocop:enable Metrics

  private

  def new_skill_values
    params.fetch(:skill)
  end

  def old_skill_id1
    params.fetch(:old_skill_id1)
  end

  def old_skill_id2
    params.fetch(:old_skill_id2)
  end

  def validate!
    return true if PeopleSkill
                   .where(skill_id: [old_skill_id1, old_skill_id2])
                   .group(:person_id)
                   .having('COUNT(skill_id) = 2')
                   .none?

    raise 'Merging these skills is not allowed since someone has rated both of them'
  end
end
