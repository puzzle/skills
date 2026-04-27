# frozen_string_literal: true

module SkillSearch
  class Search
    delegate :results, :no_matches?, :no_match_message, to: :search_filters
    delegate :rows, :count, to: :search_filters, prefix: :filter

    def initialize(params)
      @params = params
    end

    def apply_filters
      search_filters.add_row if @params[:add_row]
      search_filters.delete_row(@params[:delete_row]) if @params[:delete_row]
      search_filters.add_row if filter_count.zero?
      search_filters.apply { |ids| people_by_skill_ids(ids) }
    end

    def expert_mode = SkillSearch::ExpertMode.new(@params[:expert_mode])

    private

    def search_filters
      @search_filters ||= SearchFilters.parse(@params)
    end

    def people_by_skill_ids(ids)
      query = PeopleSkill.includes(:skill, person: :department).where(skill_id: ids)
      query = query.where(person: { department_id: @params[:department] }) if @params[:department]
      query.group_by(&:person)
    end
  end
end
