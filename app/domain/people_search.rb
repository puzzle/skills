# frozen_string_literal: true

class PeopleSearch
  SEARCHABLE_FIELDS = %w{name title competence_notes description
                         role technology location}.freeze
  attr_reader :search_terms, :entries, :search_skills

  def initialize(search_terms, search_skills: false)
    @search_terms = search_terms
    @search_skills = search_skills
    @entries = search_result
  end

  private

  def search_result
    people = []
    search_terms.each do |search_term|
      people = Person.all.search(search_term)
    end

    people = pre_load(people)
    results = []

    people.map do |p|
      found_in(p).each do |result|
        translated_attr = Person.human_attribute_name(result, count: 2)
        results.push({ person: { id: p.id, name: p.name }, found_in: translated_attr })
      end
    end
    results
  end

  def found_in(person)
    res_attributes = in_attributes(person.attributes)
    res_associations = in_associations(person)
    [res_attributes, res_associations].flatten.compact
  end

  # Load the attributes of the given people into cache
  # Without this, reflective methods accessing attributes over associations
  # would come up empty
  def pre_load(people)
    person_keys = people.map(&:id)

    Person.includes(:department, :roles, :projects, :activities,
                    :educations, :advanced_trainings, (:skills if search_skills))
          .find(person_keys)
  end

  def in_associations(person)
    association_symbols.map do |sym|
      attribute_names = in_association(person, sym)
      sym.to_s if attribute_names.any?
    end.flatten
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
      in_attributes(target.attributes)
    end
  end

  # rubocop:enable Metrics/MethodLength

  def attribute_in_array(array)
    array.map do |t|
      in_attributes(t.attributes)
    end.flatten
  end

  def in_attributes(attrs)
    attribute = searchable_fields(attrs).find_all do |_key, value|
      next if value.nil?
      search_terms.each do |search_term|
        value.downcase.include?(search_term.downcase) # PG Search is not case sensitive

      end
    end
    attribute.map!(&:first)
  end

  def searchable_fields(fields)
    keys = fields.keys & SEARCHABLE_FIELDS
    fields.slice(*keys)
  end
end
