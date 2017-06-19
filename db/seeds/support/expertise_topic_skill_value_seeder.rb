# encoding: utf-8

class ExpertiseTopicSkillValueSeeder
  def seed_expertise_topic_skill_values
    Person.all.find_each do |p|
      next if p.origin_person_id
      ExpertiseTopic.all.find_each do |et|
        seed_expertise_topc_skill_value(et, p)
      end
    end
  end

  private

  def seed_expertise_topc_skill_value(expertise_topic, person)
    ExpertiseTopicSkillValue.seed do |etsv|
      etsv.years_of_experience = Faker::Number.number(2)
      etsv.number_of_projects = Faker::Number.number(2)
      etsv.last_use = Faker::Number.between(1990, 2017)
      etsv.skill_level = Faker::Number.between(0, 4)
      etsv.comment = Faker::Hacker.adjective
      etsv.expertise_topic = expertise_topic
      etsv.person = person
    end
  end
end
