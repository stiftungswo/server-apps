# frozen_string_literal: true

require_relative 'helpers/docker_builder'
require_relative 'helpers/docker_runner'
require_relative 'helpers/environment_loader'

module DSL
  class TaskContext
    include Helpers::DockerBuilder
    include Helpers::DockerRunner
    include Helpers::EnvironmentLoader

    attr_reader :args, :site_directory

    def initialize(args, file, site_directory)
      @args = args
      @file = file
      @site_directory = site_directory
    end

    def call
      instance_eval File.open(@file, 'r:UTF-8', &:read)
    end

    def in_directory(path, &block)
      Dir.chdir(path, &block) if block_given?
    end
  end
end
