# frozen_string_literal: true

module Api::V1
  class ExtendedJsonSerializer < ApiErrorHandler::Serializers::JsonApi
    # Changes the response content to application/json instead of application/vnd.api+json.
    def render_format
      :json
    end
  end

  class ApiController < ApplicationController
    handle_api_errors(serializer: Api::V1::ExtendedJsonSerializer)
  end
end
