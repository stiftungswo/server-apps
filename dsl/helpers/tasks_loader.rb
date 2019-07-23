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

      def load_restart_task()
        restartable_sites = Dir['sites/**/*'].select do |site|
          runfile_path = "#{site}/Runfile"
          stopfile_path = "#{site}/Stopfile"

          FileTest.exist?(runfile_path) && FileTest.exist?(stopfile_path)
        end

        restartable_sites.each do |site|
          runfile_path = "#{site}/Runfile"
          stopfile_path = "#{site}/Stopfile"
          files = [stopfile_path, runfile_path]

          load_task(files, :restart)
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
        info_file = file.is_a?(Array) ? file[0] : file

        project = extract_task_namespaces(info_file).first
        environment = extract_task_namespaces(info_file).last
        file_dirname = File.dirname(info_file)

        namespace project do
          namespace environment do
            desc "#{task_name.to_s.capitalize} #{project} '#{environment}'"
            task task_name, parameters do |_t, args|
              TaskContext.new(args, file, file_dirname).call
            end
          end
        end
      end

      def extract_task_namespaces(file)
        file = file.first if file.is_a? Array

        Pathname(file).each_filename.to_a[-3..-2].map(&:to_sym)
      end
    end
  end
end
