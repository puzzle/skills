require 'rails_helper'

describe Api::People::SearchController do

  it 'filters persons for term if given' do
    expect(Person)
      .to receive(:search)
            .with("London")
            .exactly(1).times
            .and_call_original

    get :index, params: { q: %w[London] }

    alice_attrs = json[0]

    expect(alice_attrs.count).to eq(2)
    expect(alice_attrs['person']['name']).to eq('Alice Mante')
    expect(alice_attrs['found_in']['attribute']).to eq('Ort')
  end
end
