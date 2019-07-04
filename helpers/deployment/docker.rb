# frozen_string_literal: true

module Helpers
  module Deployment
    module Docker
      DEFAULT_DOCKER_PARAMS = {
        dockerfile_path: 'Dockerfile'
      }.freeze

      DOCKER_BUILD_PARAMS_MAPPING = {
        dockerfile_path: '-f',
        image_name: '-t',
        network: '--network'
      }.freeze

      def build_swo_image(image_name, build_args = nil, additional_arguments = {})
        build_docker_image({
          base_path: Dir.pwd,
          image_name: "swo/#{image_name}",
          build_args: build_args,
          dockerfile_path: 'prod.Dockerfile'
        }.merge(additional_arguments))
      end

      private

      def build_docker_image(options)
        options = DEFAULT_DOCKER_PARAMS.merge options

        base_command = %w[docker build]

        command = base_command.push(*generate_build_parameters_list(options))
                              .push(*generate_build_argument_list(options[:build_args]))
                              .push(options[:base_path])
        puts command.join ' '
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
end
