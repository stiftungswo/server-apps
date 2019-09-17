# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative 'dsl/helpers/tasks_loader'

include DSL::Helpers::TasksLoader

load_commands

RSpec::Core::RakeTask.new(:spec)
task :default => :spec
