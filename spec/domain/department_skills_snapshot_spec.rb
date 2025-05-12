require 'rails_helper'

describe PeopleSearch do
  it 'should create snapshot of all departments that have members' do
    DepartmentSkillsSnapshotBuilder.new.snapshot_all_departments

    snapshots = DepartmentSkillSnapshot.all
    expect(snapshots.pluck(:department_id)).to include(departments(:ux).id, departments(:sys).id, departments(:mid).id)
    expect(snapshots.pluck(:department_id)).not_to include(departments('dev-one').id, departments('dev-two').id)

    expect(snapshots.count).to eql(3)
    expected_department_id = Person.first.department_id
    expect(snapshots.first.department_id).to eql(expected_department_id)
    expect(snapshots.first.department_skill_levels).to eql(expected_department_id)
  end
end