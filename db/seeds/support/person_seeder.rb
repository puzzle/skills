# encoding: utf-8
class PersonSeeder
  def seed_people(names)
    seed_roles
    seed_skills

    names.each do |name|
      person = seed_person(name).first
      break unless person
      seed_person_roles(person)
      seed_people_skills(person.id)
      seed_image(person)
      associations = [:activity, :advanced_training, :project, :education, :language_skill, :people_skills, :contribution]
      associations.each do |a|
        seed_association(a, person.id)
      end

      person.projects.each do |project|
        seed_project_technology(project.id)
      end
    end

    # Allow the default logged-in user to edit themselves
    Person.find_by_name("Carl Albrecht Conf Admin")&.update(auth_user_id: 1)
    Person.find_by_name("Andreas Admin")&.update(auth_user_id: 2)
    Person.find_by_name("Eddy Editor")&.update(auth_user_id: 3)
    Person.find_by_name("Ursula User")&.update(auth_user_id: 4)
  end

  def seed_association(assoc_name, person_id)
    rand(3..9).times do
      send("seed_#{assoc_name}", person_id)
    end
  end

  private

  def seed_image(person)
    File.open('spec/fixtures/files/picture.png') do |f|
      person.update(picture: f)
    end
  end

  def seed_roles
    10.times do
      Role.seed do |r|
        r.name = Faker::Military.unique.army_rank
      end
    end
  end

  def seed_person_roles(person)
    PersonRole.seed do |pr|
      pr.person_id = person.id
      pr.role_id = rand(1..10)
      pr.person_role_level_id = PersonRoleLevel.all.pluck(:id).sample
      pr.percent = rand(1..10) * 10
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

  def seed_person(name)
    Person.seed_once(:name) do |p|
      p.birthdate = Faker::Date.between(from: 20.year.ago, to: 65.year.ago)
      p.picture = Faker::Avatar
      p.location = Faker::Games::Pokemon.location
      p.marital_status = :single
      p.updated_by = 'seed_user'
      p.name = name.to_s
      p.nationality = 'CH'
      p.title = Faker::Job.title
      p.company_id = rand(1..4)
      competence_notes = ""
      rand(5..15).times{ competence_notes << "#{Faker::Superhero.power}\n" }
      p.competence_notes = competence_notes
      p.email = Faker::Internet.email
      p.department_id = Department.all.pluck(:id).sample
    end
  end

  def seed_skills
    20.times do
      Skill.seed do |s|
        s.title = Faker::ProgrammingLanguage.unique.name
        s.radar = rand(0..3)
        s.portfolio = rand(0..2)
        s.default_set = rand(1..3) > 1
        s.category = Category.all_children.sample
      end
    end
  end

  def seed_activity(person_id)
    Activity.seed do |a|
      a.description = Faker::Hacker.say_something_smart
      a.role = Faker::Company.profession
      seed_daterange(a)
      a.person_id = person_id
    end
  end

  def seed_people_skills(person_id)
    PeopleSkill.seed_once(:person_id, :skill_id) do |ps|
      ps.person_id = person_id
      ps.skill_id = rand(1..20)
      ps.interest = rand(1..5)
      ps.level = rand(1..5)
      ps.certificate = rand(1..3) > 1
      ps.core_competence = rand(1..3) > 1
    end
  end

  def seed_advanced_training(person_id)
    AdvancedTraining.seed do |a|
      a.description = Faker::Hacker.say_something_smart
      a.created_at = Time.now
      seed_daterange(a)
      a.person_id = person_id
    end
  end

  def seed_project(person_id)
    Project.seed do |p|
      p.description = Faker::Hacker.say_something_smart
      p.title = Faker::Job.title
      p.role = Faker::Company.profession
      p.technology = Faker::Superhero.power
      seed_daterange(p)
      p.person_id = person_id
    end
  end

  def seed_education(person_id)
    Education.seed do |e|
      e.location = Faker::Educator.university
      e.title = Faker::Educator.course
      seed_daterange(e)
      e.person_id = person_id
    end
  end

  def seed_project_technology(project_id)
    ProjectTechnology.seed do |a|
      a.offer = ["Java", "Ruby", "Javascript", "C++", "C", "C#"]
      a.project_id = project_id
    end
  end

  def seed_language_skill(person_id)
    LanguageSkill.seed do |a|
      a.language = LanguageList::COMMON_LANGUAGES.collect{|l| l.iso_639_1.upcase}.sample
      a.level = %w{Keine A1 A2 B1 B2 C1 C2 Muttersprache}.sample
      a.certificate = Faker::Educator.university
      a.person_id = person_id
    end
  end

  def seed_contribution(person_id)
    Contribution.seed do |c|
      c.title = Faker::Company.name
      c.reference = Faker::Internet.url
      c.person_id = person_id
      c.year_from = rand(2000..2015)
      c.year_to = rand(2015..Time.now.year)
      c.month_from = rand(1..12)
      c.month_to = rand(1..12)
    end
  end

  def seed_daterange(record)
      year_to = random_year_to
      record.year_to = year_to
      record.month_to = year_to ? random_month : nil
      record.year_from = rand(1960..1980)
      record.month_from = random_month
  end

  def random_year_to
    years = [nil]
    10.times { years << rand(1985..2015) }
    years.sample
  end

  def random_month
    months = [nil]
    10.times { months << rand(1..12) }
    months.sample
  end
end
