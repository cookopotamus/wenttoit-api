# frozen_string_literal: true

require 'generators/rspec'
require 'rails/generators/resource_helpers'

module Rspec
  module Generators
    class ScaffoldGenerator < Base
      include ::Rails::Generators::ResourceHelpers

      source_root File.expand_path('templates', __dir__)

      class_option :api_version, default: 'v1', desc: 'Generate request specs'
      class_option :orm, desc: 'ORM used to generate the controller'
      class_option :singleton, type: :boolean, desc: 'Supply to create a singleton controller'

      argument :attributes, type: :array, default: [], banner: 'field:type field:type'

      API_REQUEST_TYPES = %w[delete get patch post put].freeze

      # Instantiates an instance of this scaffold generator.
      def initialize(*args, &blk)
        @generator_args = args.first
        super(*args, &blk)
      end

      # Creates a request spec file for each predefined api request type template.
      def generate_api_request_specs
        requests_subfolder = File.join('api', options['api_version'], ns_table_name)

        API_REQUEST_TYPES.each do |request_type|
          template("api_#{request_type}_request_spec.rb", template_file(folder: requests_subfolder, prefix: "#{request_type}_"))
        end
      end

      protected

      attr_reader :generator_args

      # support for namespaced-resources
      def ns_file_name
        return file_name if ns_parts.empty?

        "#{ns_prefix.map(&:underscore).join('/')}_#{ns_suffix.singularize.underscore}"
      end

      # support for namespaced-resources
      def ns_table_name
        return table_name if ns_parts.empty?

        "#{ns_prefix.map(&:underscore).join('/')}/#{ns_suffix.tableize}"
      end

      def ns_parts
        @ns_parts ||=
          begin
            parts = generator_args[0].split(%r{/|::})
            parts.size > 1 ? parts : []
          end
      end

      def ns_prefix
        @ns_prefix ||= ns_parts[0..-2]
      end

      def ns_suffix
        @ns_suffix ||= ns_parts[-1]
      end

      def value_for(attribute)
        raw_value_for(attribute).inspect
      end

      def raw_value_for(attribute)
        case attribute.type
        when :string
          attribute.name.titleize
        when :integer, :float
          @attribute_id_map ||= {}
          @attribute_id_map[attribute] ||= @attribute_id_map.keys.size.next + attribute.default
        else
          attribute.default
        end
      end

      def template_file(folder:, prefix: '', suffix: '')
        File.join('spec', folder, controller_class_path, "#{prefix}#{controller_file_name}#{suffix}_spec.rb")
      end

      def banner
        self.class.banner
      end
    end
  end
end
