# frozen_string_literal: true

require_relative 'command'

module DSL
  class DockerCompose
    COMPOSE_PARAMS_MAPPING = {
      file_path: '--file',
      format: '--format',
      project_name: '--project-name'
    }.freeze

    COMMAND_FLAGS_MAPPING = {
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
      (['docker-compose'] + build_compose_params + [@command] + build_command_flags + @arguments).compact
    end

    def active_flag_keys
      @flags.select { |key, value| COMMAND_FLAGS_MAPPING.key?(key) && value == true }.keys
    end

    def build_compose_params
      @flags.flat_map { |key, value| map_params(key, value) }.compact
    end

    def build_command_flags
      COMMAND_FLAGS_MAPPING.values_at(*active_flag_keys)
    end

    def map_params(key, value)
      return unless COMPOSE_PARAMS_MAPPING.key?(key)

      flag = COMPOSE_PARAMS_MAPPING[key]
      value.is_a?(Array) ? build_params_array(flag, value) : [flag, value]
    end

    def build_params_array(flag, values)
      values.flat_map { |value| [flag, value] }
    end
  end
end
