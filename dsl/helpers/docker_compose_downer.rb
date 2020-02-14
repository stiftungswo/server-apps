# frozen_string_literal: true

require_relative '../docker_compose'

module DSL
  module Helpers
    module DockerComposeDowner
      def shutdown_docker_compose_file(options = {})
        flags = {
          project_name: "#{project_name}_#{project_environment}",
          no_ansi: true
        }.merge(options)

        DockerCompose.new('down', flags)
                     .explain('Shutting down docker compose file').execute
      end
    end
  end
end
