# frozen_string_literal: true

module DSL
  class DockerContainer
    def initialize(container_name)
      @container_name = container_name
      @status = nil
    end

    def running?
      status?('running')
    end

    def dangling?
      status?('exited')
    end

    def stop
      Docker.new('stop', {}, @container_name)
            .explain('Stopping docker container').execute
    end

    def remove
      Docker.new('rm', {}, @container_name)
            .explain('Removing docker container').execute
    end

    private

    def status?(expected_status)
      status = Docker.new('inspect', { format: '{{.State.Status}}' }, @container_name)
                     .explain('Checking if container is ' + expected_status)
                     .ignore_stderr
                     .capture_stdout.execute
      status&.strip == expected_status
    end
  end
end
