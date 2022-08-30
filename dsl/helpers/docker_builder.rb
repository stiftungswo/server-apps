# frozen_string_literal: true

require_relative '../docker'

module DSL
  module Helpers
    module DockerBuilder
      def build_swo_image(options = {})
        docker_name_supplement = options.delete :docker_name_supplement

        Docker.new('build', merge_swo_options(options, docker_name_supplement), options[:base_path], '.').execute
      end

      private

      def merge_swo_options(options, docker_name_supplement)
        options.merge(
          base_path: Dir.pwd,
          tag: swo_image_name(docker_name_supplement),
          dockerfile_path: 'prod.Dockerfile'
        )
      end
    end
  end
end
