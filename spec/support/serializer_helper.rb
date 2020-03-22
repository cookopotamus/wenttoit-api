# frozen_string_literal: true

ERROR_STATUS = {
  NOT_FOUND: '404'
}.freeze

ERROR_MESSAGE = ->(type, _id = nil) { ERROR_MESSAGES[type] }

ERROR_MESSAGES = {
  NOT_FOUND: "Couldn't find User with 'id'=401a2a57-b95d-4516-8894-2b4778fe4a70"
}.freeze

def serialized_list(models)
  models.map { |model| serialized(model) }
end

def serialized(model)
  JSON.parse(model.to_json).with_indifferent_access.except(:created_at, :updated_at)
end

def serialized_error(type, id = nil)
  JSON.parse({ errors: [{ detail: ERROR_MESSAGE[type, id], status: ERROR_STATUS[type], title: 'Not Found' }] }.to_json)
end
