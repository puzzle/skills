class CategorySeeder
  def seed_categories(categories_hash)
    categories_hash.each do |parent, children|
      parent_category = Category.seed_once(:title) do |pc|
        pc.title = parent
      end.first || Category.find_by(title: parent)

      children.each do |child|
        Category.seed_once(:title) do |cc|
          cc.title = child
          cc.parent_id = parent_category.id
        end
      end
    end
  end
end
