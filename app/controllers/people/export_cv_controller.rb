# frozen_string_literal: true

class People::ExportCvController < ApplicationController
  def show
    @departments = Department.all
    @department = @departments.find(Person.find(params[:id]).department_id)
    render 'show'
  end
end
