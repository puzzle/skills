class CategorySeeder
  def seed_categories(categories)
    categories.each_with_index do |(parent, children), parent_index|
      parent_category = Category.seed(:position) do |pc|
        pc.title = parent
        pc.position = (1 + parent_index) * 100
      end.first || Category.find_by(title: parent)

      children.each_with_index do |child, child_index|
        Category.seed(:position) do |cc|
          cc.title = child
          cc.parent_id = parent_category.id
          cc.position = parent_category.position + child_index  + 1
        end
      end
    end
  end
end
