module Ptime
  module PtimeConnection
    def show
      return export if format_odt?

      @person = Person.includes(projects: :project_technologies,
                                person_roles: [:role, :person_role_level]).find(@person.id)

      Ptime::PeopleEmployees.new.update_person_data(@person)
      super
    end

    def new
      @person = Ptime::PeopleEmployees.new.create_or_find(params[:ptime_employee_id])
      redirect_to(@person)
    end
  end
end
