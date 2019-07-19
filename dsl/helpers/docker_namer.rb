# frozen_string_literal: true

require 'pathname'

module DSL
  module Helpers
    module DockerNamer
      def swo_container_name(supplement = '')
        "#{project_name}_#{project_environment}#{format_supplement(supplement)}"
      end

      def swo_image_name(supplement = '')
        "swo/#{project_name}#{format_supplement(supplement)}:#{project_environment}"
      end

      private

      def format_supplement(supplement)
        return '' if supplement.nil?

        supplement.empty? ? '' : '_' + supplement
      end

      def project_name
        project_name = project_path_fragments[-2]
        project_name.gsub('-', '_')
      end

      def project_environment
        project_path_fragments.last
      end

      def project_path_fragments
        Pathname(site_directory).each_filename.to_a
      end
    end
  end
end
