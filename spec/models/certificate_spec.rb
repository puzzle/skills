require 'rails_helper'

describe Certificate do
  fixtures :certificates

  context 'validations' do
    it 'checks whether required attribute values are present' do
      certificate = Certificate.new
      certificate.valid?

      expect(certificate.errors[:name].first).to eq('muss ausgefüllt werden')
      expect(certificate.errors[:points_value].first).to eq('muss ausgefüllt werden')
      expect(certificate.errors[:description].first).to eq('muss ausgefüllt werden')
      expect(certificate.errors[:exam_duration].first).to eq('muss ausgefüllt werden')
      expect(certificate.errors[:type_of_exam].first).to eq('muss ausgefüllt werden')
      expect(certificate.errors[:study_time].first).to eq('muss ausgefüllt werden')
    end

    it 'checks validation maximum length for attribute' do
      certificate = certificates('aws-certificate')
      certificate.name = SecureRandom.hex(101)
      certificate.provider = SecureRandom.hex(101)
      certificate.description = SecureRandom.hex(251)
      certificate.notes = SecureRandom.hex(251)
      certificate.valid?

      expect(certificate.errors[:name].first).to eq('ist zu lang (mehr als 100 Zeichen)')
      expect(certificate.errors[:provider].first).to eq('ist zu lang (mehr als 100 Zeichen)')
      expect(certificate.errors[:description].first).to eq('ist zu lang (mehr als 250 Zeichen)')
      expect(certificate.errors[:notes].first).to eq('ist zu lang (mehr als 250 Zeichen)')
    end
  end
end
