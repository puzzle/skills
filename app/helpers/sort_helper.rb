module SortHelper
  def sort_link(attr)
    link_to((ti "table.#{attr}"), sort_params(attr)) + current_mark(attr)
  end

  def people_skills
    if params[:sort_dir] && params[:sort]
      sort_people_skills
    else
      @search_results
    end
  end

  def skills
    if params[:sort_dir] && params[:sort]
      sort_skills
    else
      @skills
    end
  end

  private

  def filter_by_rated(skill)
    skill.people_skills.where.not(interest: 0)
         .or(skill.people_skills.where.not(level: 0))
         .joins(:person).order(:name)
  end

  def sort_params(attr)
    result = params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params
    result.merge(sort: attr, sort_dir: sort_dir(attr), only_path: true)
  end

  def sort_dir(attr)
    current_sort?(attr) && params[:sort_dir] == 'asc' ? 'desc' : 'asc'
  end

  def current_sort?(attr)
    params[:sort] == attr.to_s
  end

  def current_mark(attr)
    if current_sort?(attr)
      # rubocop:disable Rails/OutputSafety
      (sort_dir(attr) == 'asc' ? ' &darr;' : ' &uarr;').html_safe
      # rubocop:enable Rails/OutputSafety
    else
      ''
    end
  end

  def sort_people_skills
    @search_results = @search_results.to_a
    @search_results = if Person.attribute_names.include?(params[:sort])
                        sort_by_human_attr
                      else
                        sort_by_people_skill_attr
                      end
    params[:sort_dir] == 'asc' ? @search_results : @search_results.reverse
  end

  def sort_by_human_attr
    @search_results.sort_by do |person_skills|
      person = person_skills[0].person
      person[params[:sort]].to_s.downcase
    end
  end

  def sort_by_people_skill_attr
    @search_results.sort_by do |person_skills|
      person_skills[0][params[:sort]].to_s.downcase
    end
  end

  def sort_skills
    @skills = @skills.includes(category: :parent).to_a
    indirect_skill_attributes = %w[category members subcategory]
    @skills = if indirect_skill_attributes.include?(params[:sort])
                sort_skills_by_indirect_attributes
              else
                @skills.sort_by { |skill| skill[params[:sort]].to_s.downcase }
              end
    params[:sort_dir] == 'asc' ? @skills : @skills.reverse
  end

  def sort_skills_by_indirect_attributes
    return sort_by_subcategory if params[:sort] == 'subcategory'
    return sort_by_category if params[:sort] == 'category'

    sort_by_members if params[:sort] == 'members'
  end

  def sort_by_subcategory
    @skills.sort_by { |skill| skill.category.title.downcase }
  end

  def sort_by_category
    @skills.sort_by { |skill| skill.category.parent.title.downcase }
  end

  def sort_by_members
    @skills.sort_by { |skill| @member_counts.fetch(skill.id, 0) }
  end
end
