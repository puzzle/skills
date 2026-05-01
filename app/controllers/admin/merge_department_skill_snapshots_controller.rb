# frozen_string_literal: true

class Admin::MergeDepartmentSkillSnapshotsController < ApplicationController
  before_action :load_departments

  def new
    @merge_department_snapshots_form = MergeDepartmentSkillForm.new
  end

  def create
    @merge_department_snapshots_form = build_form
    return invalid_form unless @merge_department_snapshots_form.valid?

    old_departments = @merge_department_snapshots_form.selected_old_departments
    new_department = @merge_department_snapshots_form.selected_new_department

    merge_department_snapshots(old_departments, new_department)
    flash[:notice] = t('.success',
                       old_department_names: old_departments.pluck(:name).join(', '),
                       new_department_name: new_department.name)

    redirect_to new_admin_merge_department_skill_snapshot_path
  end

  private

  def build_form
    MergeDepartmentSkillForm.new(merge_params)
  end

  def merge_department_snapshots(old_departments, new_department)
    DepartmentSkillsSnapshotBuilder.new.merge_department_skills_to_new_department(
      old_department_ids: old_departments.ids,
      new_department_id: new_department.id
    )
  end

  def invalid_form
    flash[:alert] = @merge_department_snapshots_form.errors.full_messages.to_sentence
    redirect_to new_admin_merge_department_skill_snapshot_path
  end

  def load_departments
    @departments = Department.order(:name)
  end

  def merge_params
    params.expect(
      merge_department_skill_form: [:new_department_id,
                                    { old_department_ids: [] }]
    )
  end
end
