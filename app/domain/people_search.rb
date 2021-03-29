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

    people.map do |p|
      { person: { id: p.id, name: p.name }, found_in: found_in(p) }
    end
  end

  def found_in(person)
    res = in_attributes(person.attributes)
    res ||= in_associations(person)
    res.try(:camelize, :lower)
  end

  # Load the attributes of the given people into cache
  # Without this, reflective methods accessing attributes over associations
  # would come up empty
  def pre_load(people)
    person_keys = people.map(&:id)

    Person.includes(:department, :roles, :projects, :activities,
                    :educations, :advanced_trainings, :expertise_topics)
          .find(person_keys)
  end

  def in_associations(person)
    association_symbols.each do |sym|
      attribute_name = in_association(person, sym)
      if attribute_name
        return format('%<association>s#%<attribute_name>s',
                      association: sym.to_s, attribute_name: attribute_name)
      end
    end
    nil
  end

  def association_symbols
    Person.reflections.keys.excluding('company').map(&:to_sym)
  end

  def in_association(person, sym)
    target = person.association(sym).target
    return if target.nil?

    if target.is_a?(Array)
      attribute_in_array(target)
    else
      in_attributes(target.attributes)
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
    attribute = searchable_fields(attrs).find do |_key, value|
      next if value.nil?

      value.downcase.include?(search_term.downcase) # PG Search is not case sensitive
    end
    attribute.try(:first)
  end

  def searchable_fields(fields)
    keys = fields.keys & SEARCHABLE_FIELDS
    fields.slice(*keys)
  end
end
