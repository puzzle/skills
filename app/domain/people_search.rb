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
    matched_people = search_terms.each_with_index.inject([]) do |accumulated_people, (term, index)|
      current_matches = Person.all.search(term).to_a
      index.zero? ? current_matches : (accumulated_people & current_matches)
    end

    preload_associations(matched_people)
  end

  def preload_associations(people)
    return [] if people.empty?

    associations = [:department, :roles, :projects, :activities,
                    :educations, :advanced_trainings, :contributions]
    associations << :skills if search_skills

    Person.includes(associations).find(people.map(&:id))
  end

  def extract_match_data(person)
    matches_from_attrs = search_attributes(person.attributes)
    matches_from_assocs = search_associations(person)

    (matches_from_attrs + matches_from_assocs).flatten.compact
  end

  def search_associations(person)
    association_symbols.map do |assoc_name|
      process_association(person, assoc_name)
    end
  end

  def association_symbols
    Person.reflections.keys.excluding('company').map(&:to_sym)
  end

  def process_association(person, assoc_name)
    target = person.association(assoc_name).target
    return [] if target.blank?

    target = filter_rated_skills(person, target) if assoc_name == :skills

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
    return [] if collection.empty?

    table_name = table_name_for(collection.first)

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
    return unless record.respond_to?(:category) && record.category&.parent_id.present?#rubo

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
      next if value.blank? || extract_matching_keywords(value).empty?

      matched_keywords = extract_matching_keywords(value)

      {
        group: determine_group(key),
        attribute: key,
        keywords_in_attribute: matched_keywords,
        value: [shorten_if_to_long(value, matched_keywords)]
      }
    end
  end

  def shorten_if_to_long(value, keywords)
    value.length >= 50 ? shorten(value, keywords) : value
  end

  def shorten(text, keywords)
    words = text.split
    shorten_values = []

    keywords.each do |keyword|
      words.each_with_index do |word, index|
        if word.downcase.include?(keyword.to_s.downcase.strip)
          shorten_values << build_shorten_value(words, index)
        end
      end
    end
    shorten_values.join("\n")
  end

  def build_shorten_value(words, index)
    start_index = [0, index - 1].max
    "... #{words[start_index..(index + 1)].join(' ')} ..."
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

  def table_name_for(record)
    record.class.name.tableize.pluralize
  end

  def humanize_attributes(matched_data)
    matched_data.map do |match|
      humanized_match = match.dup

      base_attribute = Person.human_attribute_name(humanized_match[:attribute], count: 2)

      humanized_match[:attribute] = if humanized_match[:category]
                                      "#{base_attribute}/ #{humanized_match.delete(:category)}"
                                    else
                                      base_attribute
                                    end

      humanized_match
    end
  end
end
