# frozen_string_literal: true

require 'pathname'
require_relative '../task_context'

module DSL
  module Helpers
    module TasksLoader
      def load_commands
        Dir['sites/**/Deployfile'].each(&method(:load_deploy_task))
        Dir['sites/**/Runfile'].each(&method(:load_run_task))
        Dir['sites/**/Stopfile'].each(&method(:load_stop_task))
        load_restart_task
      end

      private

      def load_restart_task
        files = %w[Runfile Stopfile]

        restartable_sites = Dir['sites/**/*'].select { |site| files.all? { |file| FileTest.exist? "#{site}/#{file}" } }
        restartable_sites.each do |site|
          file = "#{site}/#{files[0]}"
          project = extract_task_namespaces(file).first
          environment = extract_task_namespaces(file).last

          namespace_task(project, environment) do
            desc "Restart #{project} '#{environment}'"
            task restart: %w[stop run]
          end
        end
      end

      def load_run_task(run_file)
        load_task(run_file, :run)
      end

      def load_deploy_task(deploy_file)
        load_task(deploy_file, :deploy, [:project_path])
      end

      def load_stop_task(stop_file)
        load_task(stop_file, :stop)
      end

      def load_task(file, task_name, parameters = [])
        project = extract_task_namespaces(file).first
        environment = extract_task_namespaces(file).last

        namespace_task(project, environment) do
          desc "#{task_name.to_s.capitalize} #{project} '#{environment}'"
          task task_name, parameters do |_t, args|
            TaskContext.new(args, file, File.dirname(file)).call
          end
        end
      end

      def namespace_task(project, environment, &block)
        namespace project do
          namespace environment, &block
        end
      end

      def extract_task_namespaces(file)
        Pathname(file).each_filename.to_a[-3..-2].map(&:to_sym)
      end
    end
  end
end
