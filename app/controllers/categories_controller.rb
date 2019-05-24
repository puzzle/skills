class CategoriesController < CrudController
  self.permitted_attrs = %i[title parent_id]

  private

  def fetch_entries
    return Category.all_parents.includes(:parent, :children) if params[:scope] == 'parents'
    return Category.includes(:parent, :children).all_children if params[:scope] == 'children'
    super.includes(:parent, :children)
  end
end
