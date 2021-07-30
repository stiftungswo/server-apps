# frozen_string_literal: true

require_relative '../docker'

module DSL
  module Helpers
    module DockerRunner
      DEFAULT_RUN_FLAGS = {
        # remove: true,
        detached: true,
        restart: 'unless-stopped'
      }.freeze

      def start_swo_docker_image(options)
        image_name_supplement = options.delete :docker_name_supplement
        command = options.delete(:command) || []
        name_override = options.delete :name_override
        container_name_supplement = name_override || image_name_supplement
        container_name = swo_container_name(container_name_supplement)

        stop_swo_docker_container(container_name_supplement)
        remove_swo_docker_container(container_name_supplement)

        flags = DEFAULT_RUN_FLAGS.merge(
          name: container_name,
          network: 'traefik'
        ).merge(options)

        args = [swo_image_name(image_name_supplement), *command].compact
        Docker.new('run', flags, *args)
              .explain('Starting SWO docker image').execute
      end

      def migrate_swo_rails_db(docker_name_supplement = '')
        flags = { remove: true, env_file: default_env_file }
        Docker.new('run', flags, swo_image_name(docker_name_supplement), 'bin/rails', 'db:migrate').execute
      end

      def migrate_swo_laravel_db(docker_name_supplement = '')
        flags = { remove: true, env_file: default_env_file }
        arguments = [swo_image_name(docker_name_supplement), 'php', 'artisan', 'migrate', '--no-interaction', '--force']
        Docker.new('run', flags, *arguments).execute
      end
    end
  end
end
