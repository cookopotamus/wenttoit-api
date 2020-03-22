# frozen_string_literal: true

require 'support/rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    "v1/swagger.json": {
      openapi: '3.0.1',
      info: { title: 'wenttoit API', version: 'v1' },
      basePath: '/api/v1',
      paths: {},
      servers: [
        {
          url: 'http://localhost:3001/api/{version}',
          description: 'The local development server.',
          variables: { version: { enum: %w[v1], default: 'v1' } }
        },
        {
          url: 'http://api-dev.wenttoit.com/{version}',
          description: 'The remote development server.',
          variables: { version: { enum: %w[v1], default: 'v1' } }
        },
        {
          url: 'https://api-stage.wentoit.com/{version}',
          description: 'The remote development server.',
          variables: { version: { enum: %w[v1], default: 'v1' } }
        },
        {
          url: 'http://api.wenttoit.com/{version}',
          description: 'The remote development server.',
          variables: { version: { enum: %w[v1], default: 'v1' } }
        }
      ],
      components: {
        responses: {
          not_found: {
            description: 'The requested resource was not found.',
            context: {
              'application/json': {
                schema: {
                  '$ref': '#/components/schemas/errors_object'
                }
              }
            }
          }
        },
        schemas: {
          errors_object: {
            type: 'object',
            properties: { '$ref': '#/components/schemas/errors' }
          },
          errors_array: {
            type: 'array',
            items: {
              '$ref': '#/components/schemas/error'
            }
          },
          error: {
            type: 'object',
            properties: {
              detail: { type: 'string' },
              status: { type: 'string' },
              title: { type: 'string' }
            },
            require: %w[detail status title]
          }
        }
      }
    }
  }
end
