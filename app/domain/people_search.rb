# frozen_string_literal: true

class PeopleSearch
  SEARCHABLE_FIELDS = %w{name title competence_notes description
                         role technology location}.freeze
  PERSONAL_DETAILS = %w[name email title person_roles roles department company birthdate nationality
                        location marital_status shortname].freeze
  CORE_COMPETENCES = %w[competence_notes skills].freeze
  attr_reader :search_terms, :entries, :search_skills

  def initialize(search_terms, search_skills: false)
    @search_terms = search_terms
    @search_skills = search_skills
    @entries = search_result
  end

  private

  def search_result
    people = []
    people = find_matches(people)
    results = []

    people.map do |p|
      results.push({ person: { id: p.id, name: p.name }, found_in: found_in_human_attrs(p) })
    end
    results
  end

  def find_matches(people)
    search_terms.each do |search_term|
      matches = Person.all.search(search_term)
      people = matches & people
      people = matches if search_term == search_terms[0]
    end
    pre_load(people)
  end

  def found_in_attrs(person)
    res_attributes = in_attributes(person.attributes)
    res_associations = in_associations(person)
    (res_attributes + res_associations).flatten
  end

  # Load the attributes of the given people into cache
  # Without this, reflective methods accessing attributes over associations
  # would come up empty
  def pre_load(people)
    person_keys = people.map(&:id)

    associations = [:department, :roles, :projects, :activities,
                    :educations, :advanced_trainings, :contributions]
    associations << :skills if search_skills

    Person.includes(associations).find(person_keys)
  end

  def in_associations(person)
    association_symbols.map do |sym|
      in_association(person, sym)
    end
  end

  def association_symbols
    Person.reflections.keys.excluding('company').map(&:to_sym)
  end

  # rubocop:disable Metrics/MethodLength
  def in_association(person, sym)
    target = person.association(sym).target
    return [] if target.nil?

    if sym == :skills
      target.filter! do |skill|
        !person.people_skills.find_by(skill_id: skill.id).unrated?
      end
    end

    if target.is_a?(Array)
      attribute_in_array(target)
    else
      attribute_not_in_array(target)
    end
  end

  # rubocop:disable Metrics/AbcSize
  def attribute_in_array(array)
    table_name = table_name_of_attr(array[0])
    in_attributes = { group: which_group(table_name), attribute: table_name,
                      keywords_in_attribute: [] }
    array.each do |t|
      in_attributes(t.attributes).each do |attribute|
        in_attributes[:keywords_in_attribute] =
          (in_attributes[:keywords_in_attribute] + attribute[:keywords_in_attribute]).uniq
        next unless table_name == 'skills'

        category_name = if t.category.parent_id.present?
                          t.parent_category.title.parameterize
                        end
        in_attributes[:group] = category_name
        in_attributes[:category] = t.parent_category.title
      end
    end
    in_attributes[:keywords_in_attribute].length.positive? ? in_attributes : []
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def attribute_not_in_array(target)
    result = in_attributes(target.attributes)
    if result.length.positive?
      result[0][:attribute] = target.class.name.downcase
    end
    result
  end

  def in_attributes(attrs)
    attribute = []
    searchable_fields(attrs).find_all do |key, value|
      next if value.nil?

      keywords_in_attribute = keywords_in_attribute(value)
      if keywords_in_attribute.length.positive?
        attribute.push({ group: which_group(key), attribute: key,
                         keywords_in_attribute: keywords_in_attribute })
      end
    end
    attribute
  end

  def which_group(key)
    if PERSONAL_DETAILS.include?(key)
      :personal_data
    elsif CORE_COMPETENCES.include?(key)
      :core_competences
    else
      key
    end
  end

  def keywords_in_attribute(value)
    keywords_in_attribute = []
    search_terms.each do |search_term|
      if value.strip.downcase.include?(search_term.strip.downcase)
        keywords_in_attribute.push(search_term)
      end
    end
    keywords_in_attribute
  end

  def searchable_fields(fields)
    keys = fields.keys & SEARCHABLE_FIELDS
    fields.slice(*keys)
  end

  def table_name_of_attr(attr)
    attr.class.name.tableize.pluralize
  end

  def found_in_human_attrs(person)
    found_in_attrs(person).each do |found_in|
      found_in[:attribute] = Person.human_attribute_name(found_in[:attribute], count: 2)
      if found_in[:category]
        found_in[:attribute] += "/ #{found_in[:category]}"
        found_in.delete(:category)
      end
    end
  end
end
