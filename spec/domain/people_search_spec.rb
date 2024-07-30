require 'rails_helper'

describe PeopleSearch do

  context 'search' do
    it 'finds in which association the search term has been found' do
        search_term = 'duckduck'
        people = PeopleSearch.new(search_term).entries
        person = people[0]
        expect(person[:found_in]).to eq('Projekte')
      end

      it 'finds in which person attribute the search term has been found' do
        search_term = 'Alice'
        people = PeopleSearch.new(search_term).entries
        person = people[0]
        expect(person[:found_in]).to eq('Name')
      end

      it 'returns nothing for nonsense search term' do
        search_term = 'lkdffjskljfkl'
        people = PeopleSearch.new(search_term).entries
        expect(people).to be_empty
      end
    end
end
