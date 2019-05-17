module Odt
  class Skillset

    def initialize(skills)
      @skills = skills
    end

    def export
      ODFReport::Report.new('lib/templates/skillset_template.odt') do |r|
        insert_skills(r)
      end
    end

    private

    attr_reader :skills

    def insert_skills(report)
      report.add_table('SKILLS', skills_list, header: true) do |t|
        t.add_column(:skill_name, :skill_name)
        t.add_column(:member_amount, :member_amount)
        t.add_column(:parent_category, :parent_category)
        t.add_column(:category, :category)
        t.add_column(:default_set, :default_set)
        t.add_column(:radar, :radar)
        t.add_column(:portfolio, :portfolio)
      end

      report.add_field(:current_date, Time.zone.today)
    end

    # rubocop:disable Metrics/MethodLength
    def skills_list
      skills.map do |skill|
        {
          skill_name: skill.title,
          member_amount: skill.people.length,
          parent_category: skill.parent_category.title,
          category: skill.category.title,
          default_set: formatted_default_set(skill.default_set),
          radar: skill.radar,
          portfolio: skill.portfolio
        }
      end
    end
    # rubocop:enable Metrics/MethodLength

    def formatted_default_set(default_set)
      return 'NEU' if default_set.nil?
      default_set ? 'JA' : 'NEIN'
    end
  end
end
