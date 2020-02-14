# frozen_string_literal: true

module DSL
  module Helpers
    module DockerComposeNamer
      def swo_compose_project_name
        "#{project_name}_#{project_environment}"
      end
    end
  end
end
