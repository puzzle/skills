class MergeDepartmentSkillForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :old_department_ids, default: []
  attribute :new_department_id, :integer

  validates :old_department_ids, presence: true
  validates :new_department_id, presence: true

  def persisted?
    false
  end
end