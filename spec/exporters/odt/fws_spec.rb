require 'rails_helper'

describe Odt::Fws do
  fixtures :people

  context 'export' do
    it 'can export' do
      person = people(:bob)
      Odt::Fws.new('development', person.id).export
    end
    it 'can export emtpy fws' do
      Odt::Fws.new('development').empty_export
    end
  end
end
