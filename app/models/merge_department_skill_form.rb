class MergeDepartmentSkillForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :old_department_ids, default: -> { [] }
  attribute :new_department_id, :integer

  validates :old_department_ids, presence: true
  validates :new_department_id, presence: true
  validate :new_department_not_in_old_departments

  def old_department_ids
    super.compact_blank.map(&:to_i)
  end

  def selected_old_departments
    Department.where(id: old_department_ids)
  end

  def selected_new_department
    Department.find(new_department_id)
  end

  private

  def new_department_not_in_old_departments
    return if new_department_id.blank?

    if old_department_ids.include?(new_department_id)
      errors.add(:new_department_id, :merge_identical_department)
    end
  end
end
