require 'rails_helper'

describe PeopleSearch do

  context 'search' do
    it 'finds in which association the search term has been found' do
      search_terms = ['duckduckgo']
      people = PeopleSearch.new(search_terms).entries
      person = people[0]
      expect(person[:found_in].any? {|found_in| found_in[:attribute] == 'Projekte'}).to eq(true)
    end

    it 'finds in which person attribute the search term has been found' do
      search_terms = ['Alice']
      people = PeopleSearch.new(search_terms).entries
      person = people[0]
      expect(person[:found_in].any? {|found_in| found_in[:attribute] == 'Name'}).to eq(true)
    end

    it 'returns nothing for nonsense search term' do
      search_terms = ['lkdffjskljfkl']
      people = PeopleSearch.new(search_terms).entries
      expect(people).to be_empty
    end

    it 'can search with multiple keywords' do
      search_terms = ["Bash", "Java", "Ruby", "BSc in Architecture", "Figma"]
      people = PeopleSearch.new(search_terms).entries
      expect(people[0][:person][:id]).to eq(people(:maximillian).id)
    end
  end
end
