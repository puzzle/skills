module Ptime
  module PeopleController
    def show
      super
      Ptime::PeopleEmployees.new.update_person_data(@person)
    end

    def new
      @person = Ptime::PeopleEmployees.new.find_or_create(params[:ptime_employee_id])
      redirect_to(@person)
    end
  end
end
