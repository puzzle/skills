# frozen_string_literal: true

class PeopleSearchSkillSerializer
  # write custom serializer to serialize object that doesn't exist as a model
  # serialize data into JSON API format
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/BlockLength
  def self.serialize(data)
    {
      data: data.map do |entry|
        {
          id: entry[:person_id].to_s,
          # set custom type to map to correct model in frontend
          type: 'people_search_skills',
          relationships: {
            person: {
              data: {
                id: entry[:person_id].to_s,
                type: 'people'
              }
            },
            skills: {
              data: entry[:skills].map do |skill|
                {
                  id: skill[:people_skill_id].to_s,
                  # set custom type to map to correct model in frontend
                  type: 'rated_skills'
                }
              end
            }
          }
        }
      end,
      included: data.flat_map do |entry|
        skills = entry[:skills].map do |skill|
          {
            id: skill[:people_skill_id].to_s,
            # set custom type to map to correct model in frontend
            type: 'rated_skills',
            attributes: {
              title: skill[:title],
              level: skill[:level],
              interest: skill[:interest],
              certificate: skill[:certificate],
              core_competence: skill[:core_competence]
            },
            relationships: {
              people: {
                data: [
                  {
                    id: entry[:person_id].to_s,
                    type: 'people'
                  }
                ]
              }
            }
          }
        end
        [
          {
            id: entry[:person_id].to_s,
            type: 'people',
            attributes: {
              name: entry[:name]
            }
          }
        ] + skills
      end
    }
  end
  # rubocop:enable Metrics/BlockLength
  # rubocop:enable Metrics/MethodLength
end
