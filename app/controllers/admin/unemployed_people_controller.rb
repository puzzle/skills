class Admin::UnemployedPeopleController < CrudController

  self.nesting = :admin
  before_action :render_unauthorized_not_conf_admin

  def self.model_class
    Person
  end
  def index
    @unemployed_people = Person.unemployed
  end

  def list_entries
    sortable = sortable?(params[:sort])
    if sortable || default_sort
      clause = [sortable ? sort_expression : nil, default_sort]
      @unemployed_people.reorder(Arel.sql(clause.compact.join(', ')))
    else
      @unemployed_people
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
