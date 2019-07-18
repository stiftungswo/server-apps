# frozen_string_literal: true

module Helpers
  module DockerRunner
    DOCKER_RUN_BASE_COMMAND = %w[docker run].freeze

    DEFAULT_RUN_FLAGS = {
      remove: true,
      detached: true
    }.freeze

    DOCKER_RUN_FLAGS_MAPPING = {
      remove: '--rm',
      detached: '-d'
    }.freeze

    DOCKER_RUN_PARAMS_MAPPING = {
      network: '--network',
      container_name: '--name',
      env_file: '--env-file'
    }.freeze

    def run_docker_image(options)
      command = extend_run_command(DOCKER_RUN_BASE_COMMAND, options)

      rename_current_docker(options[:image_name])
      Command.new(command).execute
    end

    private

    def rename_current_docker(_name)
      command = %w[docker rename]
    end

    def extend_run_command(base_command, options)
      base_command
        .push(*build_run_arguments(options))
        .push(*build_run_flags(options))
        .push(*build_labels(options[:labels]))
        .push(options[:image_name])
        .push(options[:command])
        .compact
    end

    def build_run_arguments(options)
      options_list = options.flat_map do |key, value|
        DOCKER_RUN_PARAMS_MAPPING.key?(key) ? [DOCKER_RUN_PARAMS_MAPPING[key], value] : nil
      end

      options_list.compact
    end

    def build_run_flags(options)
      DEFAULT_RUN_FLAGS
        .merge(options.slice(DEFAULT_RUN_FLAGS.keys))
        .select { |_, value| value }
        .keys
        .flat_map { |flag| DOCKER_RUN_FLAGS_MAPPING[flag] }
    end

    def build_labels(labels)
      labels&.flat_map { |label| ['-l', label] }
    end
  end
end
