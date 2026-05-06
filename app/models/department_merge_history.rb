class DepartmentMergeHistory < ApplicationRecord
  validates :target_department_id, presence: true
  validates :snapshot, presence: true
  validates :old_department_ids, presence: true

  def target_department
    Department.find_by(id: target_department_id)
  end

  def old_departments
    Department.where(id: old_department_ids)
  end
end