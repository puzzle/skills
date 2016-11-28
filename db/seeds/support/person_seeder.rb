# encoding: utf-8

class PersonSeeder
  def seed_people(names)
    names.each do |name|
      person = seed_person(name).first
      break unless person
      associations = [:competence, :activity, :advanced_training, :project, :education]
      associations.each do |a|
        seed_association(a, person.id)
      end
      rand(0..3).times do
        seed_variation(person)
      end
    end
  end

  def seed_association(assoc_name, person_id)
    rand(0..3).times do
      send("seed_#{assoc_name}", person_id)
    end
  end

  def seed_variation(person)
    person_variation = Person::Variation.create_variation(Faker::Book.title, person.id)
    associations = [:competence, :activity, :advanced_training, :project, :education]
    change_variation(person_variation)
    associations.each do |a|
      change_associations(a, person_variation)
    end
  end

  def change_associations(assoc_name, person_variation)
    associations = person_variation.send(assoc_name.to_s.pluralize)
    associations.each do |a|
      rand(0..1).times do
        send("change_#{assoc_name}", a)
      end
    end
  end

  private

  def change_variation(person_variation)
    person_variation.language = 'Deutsch, Englisch, Französisch'
    person_variation.location = Faker::Pokemon.location
    person_variation.role = Faker::Company.profession
    person_variation.title = Faker::Name.title
    person_variation.status_id = rand(1..4)
  end

  def change_activity(activity)
    activity.description = Faker::Hacker.say_something_smart
    activity.role = Faker::Company.profession
    activity.year_from = Faker::Number.between(1956, 1979)
    activity.year_to = Faker::Number.between(1980, 2016)
    activity.save!
  end

  def change_advanced_training(advanced_training)
    advanced_training.description = Faker::Hacker.say_something_smart
    advanced_training.created_at = Time.now
    advanced_training.year_from = Faker::Number.between(1956, 1979)
    advanced_training.year_to = Faker::Number.between(1980, 2016)
    advanced_training.save!
  end

  def change_project(project)
    project.description = Faker::Hacker.say_something_smart
    project.title = Faker::Name.title
    project.role = Faker::Company.profession
    project.technology = Faker::Superhero.power
    project.year_from = Faker::Number.between(1956, 1979)
    project.year_to = Faker::Number.between(1980, 2016)
    project.save!
  end

  def change_education(education)
    education.location = Faker::Educator.university
    education.title = Faker::Educator.course
    education.year_from = Faker::Number.between(1956, 1979)
    education.year_to = Faker::Number.between(1980, 2016)
    education.save!
  end

  def change_competence(competence)
    competence.description = Faker::Superhero.power
    competence.save!
  end

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
