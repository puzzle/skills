# encoding: utf-8

class PersonSeeder
  def seed_people(names)
    names.each do |test|
      person = seed_person(test).first
      rand(2...5).times do
        seed_activity(person.id)
      end
      rand(2...5).times do
        seed_advanced_training(person.id)
      end
      rand(2...5).times do
        seed_project(person.id)
      end
      rand(2...5).times do
        seed_education(person.id)
      end
      rand(2...5).times do
        seed_competence(person.id)
      end
    end
  end

  def seed_variation(person)
    Person.seed do |p|
      p.birthdate = person.birthdate
      p.profile_picture = person.profile_picture
      p.language = person.language
      p.location = person.location
      p.martial_status = person.martial_status
      p.updated_by = person.updated_by
      p.name = person.name
      p.origin = person.origin
      p.role = person.role
      p.title = person.title
      p.status_id = person.status_id
      p.origin_person_id = person.id
      p.variation_name = Faker::Book.genre
      p.variation_date = Faker::Date.between(1.year.ago, 100.days.ago)
    end
  end


  private

  def seed_person(name)
    Person.seed_once(:name) do |p|
      p.birthdate = Faker::Date.between(20.year.ago, 65.year.ago)
      p.profile_picture = Faker::Avatar.image
      p.language = 'Deutsch, Englisch, Französisch'
      p.location = Faker::Pokemon.location
      p.martial_status = 'ledig'
      p.updated_by = 'seed_user'
      p.name = name.to_s
      p.origin = Faker::StarWars.planet
      p.role = Faker::Company.profession
      p.title = Faker::Name.title
      p.status_id = rand(1..4)
    end
  end

  def seed_activity(person_id)
    Activity.seed do |a|
      a.description = Faker::Hacker.say_something_smart
      a.role = Faker::Company.profession
      a.year_from = Faker::Number.between(1956, 1979)
      a.year_to = Faker::Number.between(1980, 2016)
      a.person_id = person_id
    end
  end

  def seed_advanced_training(person_id)
    AdvancedTraining.seed do |a|
      a.description = Faker::Hacker.say_something_smart
      a.created_at = Time.now
      a.year_from = Faker::Number.between(1956, 1979)
      a.year_to = Faker::Number.between(1980, 2016)
      a.person_id = person_id
    end
  end

  def seed_project(person_id)
    Project.seed do |p|
      p.description = Faker::Hacker.say_something_smart
      p.title = Faker::Name.title
      p.role = Faker::Company.profession
      p.technology = Faker::Superhero.power
      p.year_from = Faker::Number.between(1956, 1979)
      p.year_to = Faker::Number.between(1980, 2016)
      p.person_id = person_id
    end
  end

  def seed_education(person_id)
    Education.seed do |e|
      e.location = Faker::Educator.university
      e.title = Faker::Educator.course
      e.year_from = Faker::Number.between(1956, 1979)
      e.year_to = Faker::Number.between(1980, 2016)
      e.person_id = person_id
    end
  end

  def seed_competence(person_id)
    Competence.seed do |c|
      c.description = Faker::Superhero.power
      c.person_id = person_id
    end
  end
end

