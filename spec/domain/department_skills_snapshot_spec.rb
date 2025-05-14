require 'rails_helper'

describe PeopleSearch do
  it 'should create snapshot of all departments that have members' do
    DepartmentSkillsSnapshotBuilder.new.snapshot_all_departments

    snapshots = DepartmentSkillSnapshot.all

    expect(snapshots.count).to eql(Person.distinct.pluck(:department_id).count)

    department = departments(:sys)
    snapshot = snapshots.find_by(department_id: department)

    expect(snapshot).not_to be_nil

    department_skill_levels = snapshot.department_skill_levels
    people_skills_of_department = PeopleSkill.joins(:person).where(people: {department_id: department.id})

    expect(department_skill_levels.keys).to match_array(people_skills_of_department.distinct.pluck(:skill_id).map(&:to_s))
    department_skill_levels.each do |k, v|
      expect(people_skills_of_department.where(skill_id: k.to_i).pluck(:level)).to match_array(v)
    end
  end
end