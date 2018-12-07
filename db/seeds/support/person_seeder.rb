# encoding: utf-8

class PersonSeeder
  def seed_people(names)
    names.each do |name|
      person = seed_person(name).first
      break unless person
      seed_image(person)
      associations = [:activity, :advanced_training, :project, :education, :person_competence]
      associations.each do |a|
        seed_association(a, person.id)
      end

      projects = person.projects.each do |project|
        seed_project_technology(project.id)
      end
    end
  end

  def seed_association(assoc_name, person_id)
    rand(3..9).times do
      send("seed_#{assoc_name}", person_id)
    end
  end

  private

  def seed_image(person)
    File.open('spec/fixtures/files/picture.png') do |f|
      person.update_attributes(picture: f)
    end
  end

  def change_activity(activity)
    activity.description = Faker::Hacker.say_something_smart
    activity.role = Faker::Company.profession
    activity.start_at = Faker::Date.between(60.year.ago, 40.year.ago)
    activity.finish_at = Faker::Date.between(30.year.ago, 2.year.ago)
    activity.save!
  end

  def change_advanced_training(advanced_training)
    advanced_training.description = Faker::Hacker.say_something_smart
    advanced_training.created_at = Time.now
    advanced_training.start_at = Faker::Date.between(60.year.ago, 40.year.ago)
    advanced_training.finish_at = Faker::Date.between(30.year.ago, 2.year.ago)
    advanced_training.save!
  end

  def change_project(project)
    project.description = Faker::Hacker.say_something_smart
    project.title = Faker::Name.title
    project.role = Faker::Company.profession
    project.technology = Faker::Superhero.power
    project.start_at = Faker::Date.between(60.year.ago, 40.year.ago)
    project.finish_at = Faker::Date.between(30.year.ago, 2.year.ago)
    project.save!
  end

  def change_education(education)
    education.location = Faker::Educator.university
    education.title = Faker::Educator.course
    education.start_at = Faker::Date.between(60.year.ago, 40.year.ago)
    education.finish_at = Faker::Date.between(30.year.ago, 2.year.ago)
    education.save!
  end

  def change_person_competence(person_competence)
    person_competence.category = Faker::Hacker.noun
    person_competence.offer = ["Java", "Ruby", "Javascript", "C++", "C", "C#"]
    person_competence.save!
  end

  def seed_person(name)
    Person.seed_once(:name) do |p|
      p.birthdate = Faker::Date.between(20.year.ago, 65.year.ago)
      p.language = 'Deutsch, Englisch, Französisch'
      p.picture = Faker::Avatar
      p.location = Faker::Pokemon.location
      p.martial_status = 'ledig'
      p.updated_by = 'seed_user'
      p.name = name.to_s
      p.nationality = 'CH'
      p.roles = seed_roles 
      p.title = Faker::Name.title
      p.company_id = rand(1..4)
      competences = ""
      rand(5..15).times{ competences << "#{Faker::Superhero.power}\n" }
      p.competences = competences
    end
  end

  def seed_roles
    Role.seed do |a|
      a.name = Faker::Military.unique.army_rank
    end
  end

  def seed_activity(person_id)
    Activity.seed do |a|
      a.description = Faker::Hacker.say_something_smart
      a.role = Faker::Company.profession
      a.start_at = Faker::Date.between(60.year.ago, 40.year.ago)
      a.finish_at = Faker::Date.between(30.year.ago, 2.year.ago)
      a.person_id = person_id
    end
  end

  def seed_advanced_training(person_id)
    AdvancedTraining.seed do |a|
      a.description = Faker::Hacker.say_something_smart
      a.created_at = Time.now
      a.start_at = Faker::Date.between(60.year.ago, 40.year.ago)
      a.finish_at = Faker::Date.between(30.year.ago, 2.year.ago)
      a.person_id = person_id
    end
  end

  def seed_project(person_id)
    Project.seed do |p|
      p.description = Faker::Hacker.say_something_smart
      p.title = Faker::Name.title
      p.role = Faker::Company.profession
      p.technology = Faker::Superhero.power
      p.start_at = Faker::Date.between(60.year.ago, 40.year.ago)
      p.finish_at = Faker::Date.between(30.year.ago, 2.year.ago)
      p.person_id = person_id
    end
  end

  def seed_education(person_id)
    Education.seed do |e|
      e.location = Faker::Educator.university
      e.title = Faker::Educator.course
      e.start_at = Faker::Date.between(60.year.ago, 40.year.ago)
      e.finish_at = Faker::Date.between(30.year.ago, 2.year.ago)
      e.person_id = person_id
    end
  end

  def seed_person_competence(person_id)
    PersonCompetence.seed do |a|
      a.category = Faker::Hacker.noun
      a.offer = ["Java", "Ruby", "Javascript", "C++", "C", "C#"]
      a.person_id = person_id
    end
  end

  def seed_project_technology(project_id)
    ProjectTechnology.seed do |a|
      a.offer = ["Java", "Ruby", "Javascript", "C++", "C", "C#"]
      a.project_id = project_id
    end
  end
end
