# encoding: utf-8

class ExpertiseCategorySeeder
  def seed_development_category(category, topics=[])
    seed_category('development', category, topics)
  end

  def seed_system_category(category, topics=[])
    seed_category('system_engineering', category, topics)
  end

  private

  def seed_category(discipline, category, topics)
    expertise_category = ExpertiseCategory.seed_once(:name, :discipline) do |e|
      e.name = category
      e.discipline = discipline
    end

    topics.each do |t|
      ExpertiseTopic.seed_once(:name) do |et|
        et.name = t
        et.expertise_category = expertise_category.first
      end
    end
  end
end
