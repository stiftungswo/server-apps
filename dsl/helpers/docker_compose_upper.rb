# frozen_string_literal: true

require_relative '../docker_compose'

module DSL
  module Helpers
    module DockerComposeUpper
      DEFAULT_RUN_FLAGS = {
        detached: true,
        no_ansi: true
      }.freeze

      def startup_docker_compose_file(options = {})
        flags = DEFAULT_RUN_FLAGS.merge(
          project_name: "#{project_name}_#{project_environment}"
        ).merge(options)

        DockerCompose.new('up', flags)
                     .explain('Starting up the docker compose file').execute
      end
    end
  end
end
