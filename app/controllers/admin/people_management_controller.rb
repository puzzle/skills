class Admin::PeopleManagementController < CrudController
  self.nesting = :admin
  before_action :render_unauthorized_not_conf_admin

  def self.model_class
    Person
  end

  def index
    @unemployed_people = Person.unemployed
    @not_synced_profiles = Person.where(ptime_employee_id: nil)
                                 .or(Person.where(ptime_data_provider: nil))

    @list_entries = @unemployed_people

    if Skills.use_ptime_sync?
      @list_entries = @list_entries.or(@not_synced_profiles)
    end
  end

  def list_entries
    sortable = sortable?(params[:sort])
    if sortable || default_sort
      clause = [sortable ? sort_expression : nil, default_sort]
      @list_entries.reorder(Arel.sql(clause.compact.join(', ')))
    else
      @list_entries
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
