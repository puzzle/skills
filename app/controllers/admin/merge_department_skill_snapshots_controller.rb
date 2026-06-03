# frozen_string_literal: true

class Admin::MergeDepartmentSkillSnapshotsController < ApplicationController
  before_action :load_departments

  helper_method :old_department_names

  def new
    @merge_department_snapshots_form = MergeDepartmentSkillForm.new
    @merge_histories = DepartmentMergeHistory.order(created_at: :desc)
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

    @merge_histories = DepartmentMergeHistory.order(created_at: :desc)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to new_admin_merge_department_skill_snapshot_path }
    end
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
    flash.now[:alert] = @merge_department_snapshots_form.errors.full_messages.to_sentence

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('flash-messages', partial: 'layouts/flash',
                                                                   collection: [:notice, :alert], as: :level)
      end
      format.html { redirect_to new_admin_merge_department_skill_snapshot_path }
    end
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

  def old_department_names(row)
    row.old_departments.pluck(:name).join(', ')
  end
end
