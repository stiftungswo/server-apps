# frozen_string_literal: true

require_relative 'command'

module DSL
  class Docker
    DOCKER_PARAMS_MAPPING = {
      dockerfile_path: '--file',
      tag: '--tag',
      network: '--network',
      name: '--name',
      env_file: '--env-file',
      build_args: '--build-arg',
      labels: '--label',
      format: '--format'
    }.freeze

    DOCKER_FLAGS_MAPPING = {
      remove: '--rm',
      detached: '-d',
      no_cache: '--no-cache'
    }.freeze

    def initialize(command, flags = {}, *arguments)
      @command = command
      @flags = flags
      @arguments = arguments
    end

    def execute(&block)
      Command.new(build_command).execute(&block)
    end

    def execute_with_exit_code
      return false if ENV.member? 'PRETEND_COMMAND_EXECUTION'

      system(*build_command)
    end

    private

    def build_command
      (['docker', @command] + build_flags + build_params + @arguments).compact
    end

    def build_flags
      DOCKER_FLAGS_MAPPING.values_at(*active_flag_keys)
    end

    def active_flag_keys
      @flags.select { |key, value| DOCKER_FLAGS_MAPPING.key?(key) && value == true }.keys
    end

    def build_params
      @flags.flat_map { |key, value| map_params(key, value) }.compact
    end

    def map_params(key, value)
      return unless DOCKER_PARAMS_MAPPING.key?(key)

      flag = DOCKER_PARAMS_MAPPING[key]
      value.is_a?(Array) ? build_params_array(flag, value) : [flag, value]
    end

    def build_params_array(flag, values)
      values.flat_map { |value| [flag, value] }
    end
  end
end
