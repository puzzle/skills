class Admin::PeopleManagementController < CrudController
  self.nesting = :admin
  before_action :render_unauthorized_not_conf_admin

  def self.model_class
    Person
  end

  def index
    if params[:people] == 'unemployed'
      @people = Person.unemployed
    elsif params[:people] == 'not_synced'
      @people = Person.where(ptime_employee_id: nil)
                      .or(Person.where(ptime_data_provider: nil))
    end
  end

  def destroy_person
    @person = Person.find(params['person_id'])
    if @person.destroy.destroyed?
      flash.now[:notice] = t('crud.destroy.flash.success', model: @person)
    else
      flash.now[:alert] = t('crud.destroy.flash.failure', model: @person)
    end
  end
end
