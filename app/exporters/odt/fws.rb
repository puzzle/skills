# encoding: utf-8
module Odt
  class Fws

    def initialize(discipline, person_id=nil)
      @person_id = person_id
      @discipline = discipline
    end

    def export
      ODFReport::Report.new("lib/templates/fws_#{@discipline}_template.odt") do |r|
        insert_general_sections(r)
        insert_categories(r)
      end
    end

    def empty_export
      ODFReport::Report.new("lib/templates/fws_#{@discipline}_empty_template.odt") do |r|
        insert_topics(r)
      end
    end

    private

    def insert_general_sections(r)
      r.add_field(:client, 'mg')
      r.add_field(:project, 'pcv')
      r.add_field(:section, 'dev1')
      r.add_field(:name, person.name)
      r.add_field(:title_function, person.role)
    end

    def skill_values_row(category_id)
      ExpertiseTopicSkillValue.list(@person_id, category_id).collect do |e|
        topics = expertise_export_values(e)
        topics[e.skill_level.to_sym] = 'X'
        topics
      end
    end


    def expertise_export_values(e)
      { topic: e.expertise_topic.name,
        last_use: e.last_use,
        experience: e.years_of_experience,
        projects: e.number_of_projects,
        skill: e.skill_level,
        comment: e.comment,
        trainee: '',
        junior: '',
        professional: '',
        senior: '',
        expert: '' }
    end

    def insert_categories(r)
      expertise_categories = ExpertiseCategory.list(@discipline)
      expertise_categories.each do |category|
        topics = skill_values_row(category.id)
        insert_expertise_export_values(r, topics, category)
      end
    end

    # rubocop:disable Metrics/MethodLength
    def insert_expertise_export_values(r, topics, category)
      r.add_table(category.name.upcase.delete(' '), topics, header: true) do |t|
        t.add_column(:topic, :topic)
        t.add_column(:experience, :experience)
        t.add_column(:projects, :projects)
        t.add_column(:last_use, :last_use)
        t.add_column(:comment, :comment)
        t.add_column(:trainee, :trainee)
        t.add_column(:junior, :junior)
        t.add_column(:professional, :professional)
        t.add_column(:senior, :senior)
        t.add_column(:expert, :expert)
      end
    end

    def insert_topics(r)
      expertise_categories = ExpertiseCategory.list(@discipline)
      expertise_categories.each do |category|
        topics = ExpertiseTopic.list(category.id)
        r.add_table(category.name.upcase.delete(' '), topics, header: true) do |t|
          t.add_column(:topic, :name)
        end
      end
    end

    def person
      @person ||= ::Person.find(@person_id)
    end
  end
end
