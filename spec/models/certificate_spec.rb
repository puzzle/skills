require 'rails_helper'

describe Certificate do
  fixtures :certificates

  context 'validations' do
    it 'checks whether required attribute values are present' do
      certificate = Certificate.new
      certificate.valid?

      not_null_attrs = %i[title points_value]

      not_null_attrs.each do |attr|
        expect(certificate.errors[attr].first).to eq('muss ausgefüllt werden')
      end
    end

    it 'checks validation maximum length for attribute' do
      certificate = certificates('aws-certificate')

      attrs_with_length_limit = %i[designation title provider comment type_of_exam]
      long_string = SecureRandom.hex(251)

      attrs_with_length_limit.each do |attr|
        certificate[attr] = long_string
      end

      certificate.valid?

      attrs_with_length_limit.each do |attr|
        expect(certificate.errors[attr].first).to eq('ist zu lang (mehr als 250 Zeichen)')
      end
    end
  end
end
