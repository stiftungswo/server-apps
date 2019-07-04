# frozen_string_literal: true

require_relative 'deployment/docker'
require_relative 'shell'
require_relative 'command'

module Helpers
  class TaskContext
    include Helpers::Shell
    include Helpers::Deployment::Docker

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
