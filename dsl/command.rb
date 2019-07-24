# frozen_string_literal: true

require 'open3'
require 'colorize'

module DSL
  class Command
    SHELL_FORMAT_LIGHT_BLACK = "\e[0;90;49m"
    SHELL_FORMAT_END = "\e[0m"

    attr_reader :shell_command, :explanation
    attr_writer :pipe

    def initialize(shell_command, explanation = nil)
      @shell_command = shell_command
      @explanation = explanation
      @pipe = nil
      @capture_stdout = false
      @ignore_stderr = false
    end

    def execute
      bash_log
      piped? ? execute_piped_command : execute_simple_command
    end

    def to_s
      @shell_command.join(' ')
    end

    def bash_log
      puts(((' ' * 3) + explanation + ':').bold) if explained?
      puts format_bash_command(captured_stdout? ? '?>' : '+ ')
    end

    def piped?
      !@pipe.nil?
    end

    def captured_stdout?
      @capture_stdout
    end

    def explained?
      !explanation.nil?
    end

    def ignored_stderr?
      @ignore_stderr
    end

    def pipe(pipe)
      @pipe = pipe
      self
    end

    def capture_stdout
      @capture_stdout = true
      self
    end

    def explain(explanation)
      @explanation = explanation
      self
    end

    def ignore_stderr
      @ignore_stderr = true
      self
    end

    private

    def format_bash_command(identifier)
      bash_command = "#{identifier} #{self}"
      bash_command = bash_command + ' | ' + @pipe.to_s if piped?
      bash_command.colorize(explained? ? :light_black : :white)
    end

    def execute_simple_command
      return if pretend_execution?

      if @capture_stdout
        captured_simple_command
      else
        non_captured_simple_command
      end
    end

    def non_captured_simple_command
      printf SHELL_FORMAT_LIGHT_BLACK
      system(*shell_command, ignored_stderr? ? { err: File::NULL } : {})
      printf SHELL_FORMAT_END + "\n"
    end

    def captured_simple_command
      _, stdout, stderr, = Open3.popen3(*shell_command)
      printf stderr.read.red unless stderr.eof? || ignored_stderr?
      puts
      stdout.read
    end

    def execute_piped_command
      return if pretend_execution?

      if @capture_stdout
        last_std, = Open3.pipeline_r(@shell_command, @pipe.shell_command)
        last_std.read
      else
        status_list = Open3.pipeline(@shell_command, @pipe.shell_command)
        status_list.all?(&:success?)
      end
    end

    def pretend_execution?
      !ENV['PRETEND_COMMAND_EXECUTION'].nil?
    end
  end
end
