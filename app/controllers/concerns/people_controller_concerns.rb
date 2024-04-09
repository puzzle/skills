# frozen_string_literal: true

module PeopleControllerConcerns
  private

  def set_nationality2
    if params.include?(:has_nationality2) && false?(params[:has_nationality2][:checked])
      params[:person][:nationality2] = nil
    end
  end
end
