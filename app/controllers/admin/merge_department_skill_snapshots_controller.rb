# frozen_string_literal: true

class Admin::MergeDepartmentSkillSnapshotsController < ApplicationController
  before_action :load_departments

  def new
  end

  def create
    DepartmentSkillsSnapshotBuilder.new.merge_department_skills_to_new_department(
      old_department_ids: old_department_ids,
      new_department_id: new_department_id
    )

    flash[:notice] = t(
      ".success",
      old_department_ids: old_department_ids.join(", "),
      new_department_id: new_department_id
    )

    redirect_to new_admin_merge_department_skill_snapshots_path
  end

  private

  def load_departments
    @departments = Department.order(:name)
  end

  private

  def merge_params
    params.except(:authenticity_token, :commit, :locale, :controller, :action)
          .permit(:new_department_id, old_department_ids: [])
  end

  def old_department_ids
    Array(merge_params[:old_department_ids]).reject(&:blank?).map(&:to_i)
  end

  def new_department_id
    merge_params[:new_department_id].to_i
  end
end
