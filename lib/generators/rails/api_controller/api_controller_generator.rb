# frozen_string_literal: true

require 'rails/generators/resource_helpers'

module Rails
  module Generators
    class ApiControllerGenerator < NamedBase
      include ResourceHelpers

      source_root File.expand_path('templates', __dir__)
      check_class_collision suffix: 'Controller'

      class_option :helper, type: :boolean
      class_option :orm, banner: 'NAME', type: :string, required: true, desc: 'ORM to generate the controller for'
      class_option :skip_routes, type: :boolean, desc: "Don't add routes to config/routes.rb."
      class_option :version, type: :string, default: 'v1'

      argument :attributes, type: :array, default: [], banner: 'field:type field:type'

      # Creates a controller file in the correct version directory using the predefined api template.
      def create_controller_files
        template(
          'api_controller.rb',
          File.join('app', 'controllers', 'api', options['version'], controller_class_path, "#{controller_file_name}_controller.rb")
        )
      end

      hook_for :resource_route, required: true do |route|
        invoke route unless options.skip_routes?
      end

      hook_for :test_framework, as: :scaffold

      private

      def permitted_params
        attachments, others = attributes_names.partition { |name| attachments?(name) }
        params = others.map { |name| ":#{name}" }
        params += attachments.map { |name| "#{name}: []" }
        params.join(', ')
      end

      def attachments?(name)
        attribute = attributes.find { |attr| attr.name == name }
        attribute&.attachments?
      end
    end
  end
end
