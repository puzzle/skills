# frozen_string_literal: true

module Odt
  class Fws

    def initialize(discipline, person_id = nil)
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
        insert_empty_categories(r)
      end
    end

    private

    def insert_general_sections(report)
      report.add_field(:client, 'mg')
      report.add_field(:project, 'pcv')
      report.add_field(:section, 'dev1')
      report.add_field(:name, person.name)
      report.add_field(:title_function, person.roles)
    end

    def skill_values_row(category_id)
      ExpertiseTopicSkillValue.list(@person_id, category_id).collect do |e|
        topics = expertise_export_values(e).with_indifferent_access
        topics[e.skill_level] = 'X'
        topics
      end
    end

    # rubocop:disable Metrics/MethodLength
    def expertise_export_values(exp_topic_skill_value)
      { topic: exp_topic_skill_value.expertise_topic.name,
        last_use: exp_topic_skill_value.last_use,
        experience: exp_topic_skill_value.years_of_experience,
        projects: exp_topic_skill_value.number_of_projects,
        skill: exp_topic_skill_value.skill_level,
        comment: exp_topic_skill_value.comment,
        trainee: '',
        junior: '',
        professional: '',
        senior: '',
        expert: '' }
    end
    # rubocop:enable Metrics/MethodLength

    def insert_categories(report)
      expertise_categories = ExpertiseCategory.list(@discipline)
      expertise_categories.each do |category|
        topics = skill_values_row(category.id)
        insert_expertise_export_values(report, topics, category)
      end
    end

    # rubocop:disable Metrics/MethodLength
    def insert_expertise_export_values(report, topics, category)
      report.add_table(category.name.upcase.delete(' '), topics, header: true) do |t|
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
    # rubocop:enable Metrics/MethodLength

    def insert_empty_categories(report)
      expertise_categories = ExpertiseCategory.list(@discipline)
      expertise_categories.each do |category|
        topics = ExpertiseTopic.list(category.id)
        report.add_table(category.name.upcase.delete(' '), topics, header: true) do |t|
          t.add_column(:topic, :name)
        end
      end
    end

    def person
      @person ||= ::Person.find(@person_id)
    end
  end
end
