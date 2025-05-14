require 'rails_helper'

RSpec.describe DepartmentSkillSnapshot, type: :model do
  it 'should correctly serialize department_skill_levels' do
    department_skill_snapshot = DepartmentSkillSnapshot.create!(department_id: Department.first.id, department_skill_levels: {"1" => [2, 2, 3], "2" => [3, 3, 1]})

    expect(department_skill_snapshot.department_skill_levels.is_a? Hash).to eql(true)
  end
end
