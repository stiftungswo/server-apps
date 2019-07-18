# frozen_string_literal: true

require_relative '../docker'

module DSL
  module Helpers
    module DockerRunner
      DEFAULT_RUN_FLAGS = {
        remove: false,
        detached: true
      }.freeze

      def start_swo_docker_image(options)
        image_name = options.delete :image_name

        stop_container image_name if container_running? image_name

        flags = DEFAULT_RUN_FLAGS.merge(
          name: image_name,
          network: 'traefik',
        ).merge(options)

        Docker.new('run', flags, "swo/#{image_name}").execute
      end

      private

      def stop_container(image_name)
        Docker.new('stop', {}, image_name).execute
      end

      def container_running?(image_name)
        Docker.new('inspect', { format: '{{.State.Running}}' }, image_name).execute_with_exit_code
      end
    end
  end
end
