class Admin::UnifiedSkillsController < CrudController
  self.nesting = :admin
  self.permitted_attrs = [:old_skill_id1, :old_skill_id2, { skill:
                              [:id, :title, :radar, :portfolio, :default_set, :category_id] }]
  before_action :render_unauthorized_not_admin

  def index
    @skill = Skill.find_by(id: params[:old_skill_id1]) || Skill.new
  end

  def create
    ActiveRecord::Base.transaction do
      params.permit!
      validate!

      old_skill1 = Skill.find(old_skill_id1)
      old_skill2 = Skill.find(old_skill_id2)

      merge_skills(old_skill1, old_skill2)
    end
  end

  private

  def merge_skills(old_skill1, old_skill2)
    new_skill = Skill.create!(new_skill_values)
    PeopleSkill.where(skill_id: [old_skill_id1, old_skill_id2]).update!(skill_id: new_skill.id)
    UnifiedSkill.create!(skill1_attrs: old_skill1.attributes, skill2_attrs: old_skill2.attributes,
                         unified_skill_attrs: new_skill.attributes)

    old_skill1.delete
    old_skill2.delete
  end

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
    validate_skill_ids_are_present!
    validate_skills_are_unique!
    validate_no_one_rated_both_skills!
  end

  def validate_skill_ids_are_present!
    return true if old_skill_id1.present? && old_skill_id2.present?

    raise 'Either one or both skill ids are missing'
  end

  def validate_skills_are_unique!
    return true if old_skill_id1 != old_skill_id2

    raise 'Merging a skill with itself is not possible'
  end

  def validate_no_one_rated_both_skills!
    return true if PeopleSkill
                   .where(skill_id: [old_skill_id1, old_skill_id2])
                   .group(:person_id)
                   .having('COUNT(skill_id) = 2')
                   .none?

    raise 'Merging these skills is not allowed since someone has rated both of them'
  end
end
