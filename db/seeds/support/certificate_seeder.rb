class CertificateSeeder
  def seed_certificates
    20.times do
      Certificate.seed_once(:title) do |cert|
        cert.designation = Faker::Educator.degree
        cert.title = Faker::Company.bs.upcase_first
        cert.provider = Faker::Company.name
        cert.points_value = [0, 0.5, 1, 1.5].sample
        cert.comment = Faker::Company.bs.upcase_first
        cert.course_duration = Faker::Number.between(from: 1, to: 10)
        cert.exam_duration = Faker::Number.between(from: 60, to: 240).round(-1)
        cert.type_of_exam = ['Multiple choice', 'Theoretical', 'Practical', 'Case study', 'Written work'].sample
        cert.study_time = Faker::Number.between(from: 1, to: 10)
      end
    end
  end
end