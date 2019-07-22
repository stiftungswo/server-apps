# frozen_string_literal: true

require_relative '../docker'

module DSL
  module Helpers
    module DockerRunner
      DEFAULT_RUN_FLAGS = {
        remove: true,
        detached: true
      }.freeze

      def start_swo_docker_image(options)
        docker_name_supplement = options.delete :docker_name_supplement
        container_name = swo_container_name(docker_name_supplement)

        stop_container container_name if container_running? container_name

        flags = DEFAULT_RUN_FLAGS.merge(
          name: container_name,
          network: 'traefik'
        ).merge(options)

        Docker.new('run', flags, swo_image_name(docker_name_supplement)).execute
      end

      def migrate_swo_rails_db(docker_name_supplement = '')
        flags = { remove: true, env_file: default_env_file }
        Docker.new('run', flags, swo_image_name(docker_name_supplement), 'bin/rails', 'db:migrate').execute
      end

      private

      def stop_container(image_name)
        Docker.new('stop', {}, image_name).execute
      end

      def container_running?(container_name)
        Docker.new('inspect', { format: '{{.State.Running}}' }, container_name).execute_with_exit_code
      end
    end
  end
end
