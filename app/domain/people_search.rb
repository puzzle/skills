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
    @entries = perform_search
  end

  private

  def perform_search
    find_matching_people.map do |person|
      {
        person: { id: person.id, name: person.name },
        found_in: humanize_attributes(extract_match_data(person))
      }
    end
  end

  def find_matching_people
    matched_people = search_terms.reduce(Person.all) do |scope, term|
      scope.search(term)
    end

    preload_associations(matched_people)
  end

  def preload_associations(people)
    associations = [:department, :roles, :projects, :activities,
                    :educations, :advanced_trainings, :contributions]

    if search_skills
      associations << :skills
      associations << :people_skills
    end

    people.includes(associations)
  end

  def extract_match_data(person)
    attribute_matches = search_attributes(person.attributes)
    association_matches = search_associations(person)

    (attribute_matches + association_matches).flatten.compact
  end

  def search_associations(person)
    association_symbols.map do |association_name|
      process_association(person, association_name)
    end
  end

  def association_symbols
    Person.reflections.keys.excluding('company').map(&:to_sym)
  end

  def process_association(person, association_name)
    target = person.association(association_name).target

    target = filter_rated_skills(person, target) if association_name == :skills

    target.is_a?(Array) ? process_collection(target) : process_single_record(target)
  end

  def filter_rated_skills(person, skills)
    people_skills_map = person.people_skills.index_by(&:skill_id)

    skills.select do |skill|
      people_skill = people_skills_map[skill.id]
      people_skill && !people_skill.unrated?
    end
  end

  def process_collection(collection)
    table_name = collection.first.class.name.tableize.pluralize

    collection.filter_map do |record|
      matched_attributes = search_attributes(record.attributes)
      next if matched_attributes.empty?

      build_collection_match(record, table_name, matched_attributes)
    end
  end

  def build_collection_match(record, table_name, matched_attributes)
    keywords = matched_attributes.flat_map { |attr| attr[:keywords_in_attribute] }.uniq
    last_match = matched_attributes.last

    match_data = {
      group: determine_group(table_name),
      attribute: table_name,
      keywords_in_attribute: keywords,
      value: last_match[:value]
    }

    append_skill_category_data!(match_data, record) if table_name == 'skills'

    match_data
  end

  def append_skill_category_data!(match_data, record)
    return unless record.respond_to?(:category) && record.category&.parent_id.present?

    parent_category = record.parent_category
    match_data[:group] = parent_category.title.parameterize
    match_data[:category] = parent_category.title
  end

  def process_single_record(record)
    results = search_attributes(record.attributes)

    if results.any?
      results.first[:attribute] = record.class.name.downcase
    end

    results
  end

  def search_attributes(attributes)
    searchable_fields(attributes).filter_map do |key, value|
      matched_keywords = extract_matching_keywords(value)

      next if matched_keywords.empty?

      {
        group: determine_group(key),
        attribute: key,
        keywords_in_attribute: matched_keywords,
        value: shorten_if_too_long(value, matched_keywords)
      }
    end
  end

  def shorten_if_too_long(value, keywords)
    value_as_string = value.to_s
    value_as_string.length >= 30 ? shorten(value_as_string, keywords) : value
  end

  def shorten(text, keywords)
    snippets = keywords.flat_map do |keyword|
      escaped_keyword = Regexp.escape(keyword.to_s.strip)

      # Matches the keyword along with its immediate surrounding context
      # (up to one word before and one word after).
      regex = /(?:\S+\s+)?\S*#{escaped_keyword}\S*(?:\s+\S+)?/i

      text.scan(regex).map do |match|
        "... #{match} ..."
      end
    end

    snippets.join("\n")
  end

  def extract_matching_keywords(value)
    normalized_value = value.to_s.strip.downcase

    search_terms.select do |search_term|
      normalized_value.include?(search_term.strip.downcase)
    end
  end

  def determine_group(key)
    if PERSONAL_DETAILS.include?(key)
      :personal_data
    elsif CORE_COMPETENCES.include?(key)
      :core_competences
    else
      key
    end
  end

  def searchable_fields(fields)
    keys = fields.keys & SEARCHABLE_FIELDS
    fields.slice(*keys)
  end

  def humanize_attributes(matched_data)
    matched_data.map do |match|
      base_attribute = Person.human_attribute_name(match[:attribute], count: 2)

      match[:attribute] = if match[:category]
                            "#{base_attribute}/ #{match.delete(:category)}"
                          else
                            base_attribute
                          end

      match
    end
  end
end
