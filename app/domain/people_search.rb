# frozen_string_literal: true

class PeopleSearch
  SEARCHABLE_FIELDS = %w{name title competence_notes description
                         role technology location}.freeze
  attr_reader :search_term, :entries

  def initialize(search_term)
    @search_term = search_term
    @entries = search_result
  end

  private

  def search_result
    people = Person.all.search(search_term)
    people = pre_load(people)
    result = []

    people.each do |p|
      result.push(
        person: { id: p.id, name: p.name },
        found_in: found_in(p)
      )
    end
    result
  end

  def found_in(person)
    res = in_attributes(person.attributes)
    res = in_associations(person) if res.nil?
    res.nil? ? res : res.camelize(:lower)
  end

  # Load the attributes of the given people into cache
  # Without this, reflective methods accessing attributes over associations
  # would come up empty
  def pre_load(people)
    person_keys = []
    people.each do |p|
      person_keys.push p.id
    end

    Person.includes(:department, :roles, :projects, :activities,
                    :educations, :advanced_trainings, :expertise_topics)
          .find(person_keys)
  end

  def in_associations(person)
    association_symbols.each do |sym|
      a = in_association(person, sym)
      if a
        return format('%<association>s#%<attribute_name>s',
                      association: sym.to_s, attribute_name: a)
      end
    end
    nil
  end

  def association_symbols
    keys = []
    Person.reflections.keys.each do |key|
      keys.push key.to_sym
    end
    keys
  end

  def in_association(person, sym)
    target = person.association(sym).target
    if target.is_a?(Array)
      return attribute_in_array(target)
    else
      return in_attributes(target.attributes)
    end
  end

  def attribute_in_array(array)
    array.each do |t|
      attribute = in_attributes(t.attributes)
      return attribute unless attribute.nil?
    end
    nil
  end

  def in_attributes(attrs)
    searchable_fields(attrs).each_pair do |key, value|
      return key if value.downcase.include?(search_term.downcase) # PG Search is not case sensitive
    end
    nil
  end

  def searchable_fields(fields)
    fields.keys.each do |key|
      fields.delete(key) unless SEARCHABLE_FIELDS.include?(key)
    end
    fields
  end

end
