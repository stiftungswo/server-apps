# frozen_string_literal: true

require_relative '../docker'

module DSL
  module Helpers
    module DockerBuilder
      def build_swo_image(options)
        flags = options.merge(
          base_path: Dir.pwd,
          tag: "swo/#{options[:image_name]}",
          dockerfile_path: 'prod.Dockerfile',
          no_cache: true
        )
        Docker.new('build', flags, options[:base_path], '.').execute
      end
    end
  end
end
