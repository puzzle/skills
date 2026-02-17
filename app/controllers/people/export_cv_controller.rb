# frozen_string_literal: true

class People::ExportCvController < ApplicationController
  def show
    @department = Department.find(Person.find(params[:id]).department_id)
    render 'show'
  end
end
