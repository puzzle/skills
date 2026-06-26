# frozen_string_literal: true

class PeopleSearch
  SEARCHABLE_FIELDS = %w[name title competence_notes description role technology location].freeze
  PERSONAL_DETAILS  = %w[name title].freeze
  CORE_COMPETENCES  = %w[competence_notes].freeze
  SKILLS = %w[skills].freeze
  ASSOCIATIONS = %i[department roles projects activities educations advanced_trainings
                    contributions skills].freeze
  PERSON_FIELDS = (PERSONAL_DETAILS + CORE_COMPETENCES).freeze

  attr_reader :search_terms, :search_skills, :categories,
              :selected_personal_details, :selected_associations, :entries, :handle_whitespaces

  def initialize(search_terms, search_skills: false, categories: nil, handle_whitespaces: false)
    @search_terms = search_terms
    @search_skills = search_skills
    @categories = Array(categories).compact_blank.map(&:to_s)
    @handle_whitespaces = handle_whitespaces

    filter_by_category

    @entries = perform_search
  end

  private

  def filter_by_category
    if @categories.empty?
      requested_personal_details = PERSON_FIELDS
      requested_associations = ASSOCIATIONS
    else
      requested_personal_details = PERSON_FIELDS & @categories
      requested_associations = (ASSOCIATIONS & @categories).map(&:to_sym)
    end

    use_defaults = requested_personal_details.empty? && requested_associations.empty?

    set_selected_category(requested_personal_details, requested_associations, use_defaults)
  end

  def set_selected_category(requested_personal_details, requested_associations, use_defaults)
    @selected_personal_details = use_defaults ? PERSONAL_DETAILS.dup : requested_personal_details
    @selected_associations = use_defaults ? ASSOCIATIONS.dup : requested_associations
  end

  def perform_search
    matching_people = find_matching_people
    matching_people += find_matching_people(handle_whitespaces: true) if handle_whitespaces
    matching_people.uniq.map do |person|
      {
        person: { id: person.id, name: person.name },
        found_in: humanize_attributes(extract_match_data(person))
      }
    end
  end

  def find_matching_people(handle_whitespaces: false)
    matched_people = search_terms.reduce(Person.all) do |scope, term|
      if handle_whitespaces
        scope.search(term.gsub(/\s+/, ''))
      else
        scope.search(term)
      end
    end

    preload_associations(matched_people)
  end

  def preload_associations(people)
    associations_to_load = @selected_associations.dup
    associations_to_load -= [:skills] unless search_skills
    people.includes(associations_to_load)
  end

  def extract_match_data(person)
    person_attributes = person.attributes.slice(*@selected_personal_details)

    attribute_matches = search_attributes(person_attributes)
    association_matches = search_associations(person)

    (attribute_matches + association_matches).flatten.compact
  end

  def search_associations(person)
    association_symbols.map do |association_name|
      process_association(person, association_name)
    end
  end

  def association_symbols
    associations = (@selected_associations || Person.reflections.keys).map(&:to_s)
    associations.excluding('company', 'auth_user').map(&:to_sym)
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
    results.first[:attribute] = record.class.name.downcase if results.any?
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
      escaped_keyword = Regexp.escape(normalized_keyword(keyword))
      regex = /(?:\S+\s+)?\S*#{escaped_keyword}\S*(?:\s+\S+)?/i
      text = text.gsub("\n", ' ').strip

      matches(text, regex).map { match_to_text(it, text.length) }
    end
    snippets.join("\n")
  end

  def normalized_keyword(keyword)
    if @handle_whitespaces
      keyword.to_s.gsub(/\s+/, '')
    else
      keyword.to_s.strip
    end
  end

  def matches(string, regex)
    start_at = 0
    matches  = []
    while (match = string.match(regex, start_at))
      matches.push(match)
      start_at = match.end(0)
    end
    matches
  end

  def match_to_text(match, text_length)
    pre = '...' unless match.begin(0).zero?
    post = '...' unless match.end(0) == text_length
    [pre, match.to_s.squish, post].compact.join(' ')
  end

  def extract_matching_keywords(value)
    normalized_value = value.to_s.strip.downcase

    search_terms.select do |search_term|
      if handle_whitespaces
        normalized_value.gsub(/\s+/, '').include?(search_term.gsub(/\s+/, '').downcase)
      else
        normalized_value.include?(search_term.strip.downcase)
      end
    end
  end

  def determine_group(key)
    if PERSONAL_DETAILS.include?(key)
      'personal-data'
    elsif CORE_COMPETENCES.include?(key)
      'core-competences'
    else
      key.dasherize
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
