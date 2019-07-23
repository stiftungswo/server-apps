# frozen_string_literal: true

require_relative '../docker_compose'

module DSL
  module Helpers
    module DockerComposeUpper
      DEFAULT_RUN_FLAGS = {
        detached: true
      }.freeze

      def start_up_docker_compose_file(options = {})
        flags = DEFAULT_RUN_FLAGS.merge(
          project_name: "#{project_name}_#{project_environment}"
        ).merge(options)

        DockerCompose.new('up', flags).execute
      end
    end
  end
end
