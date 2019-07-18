# frozen_string_literal: true

module Helpers
  module DockerBuilder
    DEFAULT_DOCKER_PARAMS = {
      dockerfile_path: 'Dockerfile'
    }.freeze

    DOCKER_BUILD_PARAMS_MAPPING = {
      dockerfile_path: '-f',
      image_name: '-t',
      network: '--network'
    }.freeze

    DOCKER_BUILD_BASE_COMMAND = %w[docker build].freeze

    def build_swo_image(options)
      build_docker_image(options.merge(
        base_path: Dir.pwd,
        image_name: "swo/#{options[:image_name]}",
        dockerfile_path: 'prod.Dockerfile'
      ))
    end

    private

    def build_docker_image(options)
      options = DEFAULT_DOCKER_PARAMS.merge options

      command = DOCKER_BUILD_BASE_COMMAND
                .dup
                .push(*generate_build_parameters_list(options))
                .push(*generate_build_argument_list(options[:build_args]))
                .push(options[:base_path])

      Command.new(command).execute
    end

    def generate_build_parameters_list(options)
      options_list = options.flat_map do |key, value|
        DOCKER_BUILD_PARAMS_MAPPING.key?(key) ? [DOCKER_BUILD_PARAMS_MAPPING[key], value] : nil
      end

      options_list.compact
    end

    def generate_build_argument_list(arguments)
      arguments&.flat_map { |argument| ['--build-arg', argument] }
    end
  end
end
