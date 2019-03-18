class CategoriesController < CrudController
  self.permitted_attrs = %i[title parent_id]

  private

  def fetch_entries
    return Category.all_parents if params[:scope] == 'parents'
    super
  end
end
