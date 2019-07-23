# frozen_string_literal: true

require_relative '../docker_compose'

module DSL
  module Helpers
    module DockerComposeDowner
      def shutdown_docker_compose_file(options = {})
        flags = {
          project_name: "#{project_name}_#{project_environment}"
        }.merge(options)

        DockerCompose.new('down', flags).execute
      end
    end
  end
end
