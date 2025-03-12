class CertificateSeeder
  def seed_certificates
    20.times do
      Certificate.seed_once(:name) do |cert|
        cert.name = Faker::Educator.degree
        cert.points_value = [0, 0.5, 1, 1.5].sample
        cert.description = Faker::Company.bs.upcase_first
        cert.provider = Faker::Company.name
        cert.exam_duration = Faker::Number.between(from: 60, to: 240)/10.floor*10
        cert.type_of_exam = ['Multiple choice', 'Theoretical', 'Practical', 'Case study', 'Written work'].sample
        cert.study_time = Faker::Number.between(from: 1, to: 10)
        cert.notes = Faker::Company.bs.upcase_first
      end
    end
  end
end