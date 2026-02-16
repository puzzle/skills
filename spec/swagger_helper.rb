# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ],
      components: {
        schemas: {
          CvCollectionResponse: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/CvResource' }
              }
            }
          },

          CvResource: {
            type: :object,
            properties: {
              id: { type: :string, example: '1' },
              type: { type: :string, example: 'cv' },
              attributes: { '$ref' => '#/components/schemas/CvAttributes' },
              relationships: { '$ref' => '#/components/schemas/CvRelationships' }
            },
            required: %w[id type attributes]
          },

          CvAttributes: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Jorah Mormont' },
              title: { type: :string, example: 'Direct Specialist' },
              email: { type: :string, example: 'anthony@bartell-stehr.test' },
              birthdate: { type: :string, format: :date, example: '1968-12-16' },
              location: { type: :string, example: 'Celestic Town' },
              nationality: { type: :string, example: 'CH' },
              nationality2: { type: :string, nullable: true },
              marital_status: { type: :string, example: 'single' },
              competence_notes: { type: :string },
              picture_url: { type: :string },
              # Nested Arrays using Refs
              roles: { type: :array, items: { '$ref' => '#/components/schemas/Role' } },
              skills: { type: :array, items: { '$ref' => '#/components/schemas/Skill' } },
              language_skills: { type: :array, items: { '$ref' => '#/components/schemas/LanguageSkill' } },
              projects: { type: :array, items: { '$ref' => '#/components/schemas/Project' } },
              activities: { type: :array, items: { '$ref' => '#/components/schemas/Activity' } },
              educations: { type: :array, items: { '$ref' => '#/components/schemas/Education' } },
              advanced_trainings: { type: :array, items: { '$ref' => '#/components/schemas/AdvancedTraining' } },
              contributions: { type: :array, items: { '$ref' => '#/components/schemas/Contribution' } }
            }
          },

          Role: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              created_at: { type: :string, format: :'date-time' },
              updated_at: { type: :string, format: :'date-time' }
            }
          },
          Skill: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              category_id: { type: :integer },
              portfolio: { type: :string },
              radar: { type: :string },
              default_set: { type: :boolean }
            }
          },
          LanguageSkill: {
            type: :object,
            properties: {
              id: { type: :integer },
              language: { type: :string },
              level: { type: :string },
              certificate: { type: :string }
            }
          },
          Project: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              role: { type: :string },
              technology: { type: :string },
              description: { type: :string },
              display_in_cv: { type: :boolean },
              year_from: { type: :integer },
              year_to: { type: :integer, nullable: true },
              month_from: { type: :integer, nullable: true },
              month_to: { type: :integer, nullable: true }
            }
          },
          Activity: {
            type: :object,
            properties: {
              id: { type: :integer },
              role: { type: :string },
              description: { type: :string },
              display_in_cv: { type: :boolean },
              year_from: { type: :integer },
              year_to: { type: :integer, nullable: true },
              month_from: { type: :integer, nullable: true },
              month_to: { type: :integer, nullable: true }
            }
          },
          Education: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              location: { type: :string },
              display_in_cv: { type: :boolean },
              year_from: { type: :integer },
              year_to: { type: :integer, nullable: true }
            }
          },
          AdvancedTraining: {
            type: :object,
            properties: {
              id: { type: :integer },
              description: { type: :string },
              display_in_cv: { type: :boolean },
              year_from: { type: :integer },
              year_to: { type: :integer, nullable: true }
            }
          },
          Contribution: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              reference: { type: :string },
              display_in_cv: { type: :boolean },
              year_from: { type: :integer },
              year_to: { type: :integer }
            }
          },

          # 5. Relationships
          CvRelationships: {
            type: :object,
            properties: {
              company: {
                type: :object,
                properties: {
                  data: {
                    type: :object,
                    properties: {
                      id: { type: :string },
                      type: { type: :string }
                    }
                  }
                }
              },
              department: {
                type: :object,
                properties: {
                  data: {
                    type: :object,
                    properties: {
                      id: { type: :string },
                      type: { type: :string }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  config.openapi_format = :yaml
end