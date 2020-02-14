# frozen_string_literal: true

require_relative '../docker'
require_relative '../docker_container'

module DSL
  module Helpers
    module DockerStopper
      def stop_swo_docker_container(docker_name_supplement = nil)
        container = DockerContainer.new swo_container_name(docker_name_supplement)

        container.stop if container.running?
      end
    end
  end
end
