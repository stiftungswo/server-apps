# frozen_string_literal: true

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
    end
  end
end
