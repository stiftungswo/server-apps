# frozen_string_literal: true

module Helpers
  class Command
    attr_reader :shell_command
    attr_writer :pipe

    def initialize(shell_command)
      @shell_command = shell_command
      @pipe = nil
    end

    def execute(&block)
      callback = block || method(:puts)

      if piped?
        puts "+ #{self} | #{@pipe}"

        execute_piped_command
      else
        puts "+ #{self}"

        execute_simple_command(&callback)
      end
    end

    def to_s
      @shell_command.join(' ')
    end

    def piped?
      !@pipe.nil?
    end

    def pipe(pipe)
      @pipe = pipe
      self
    end

    private

    def execute_simple_command(&callback)
      IO.popen(@shell_command, err: %i[child out]).each(&callback) unless pretend_execution?
    end

    def execute_piped_command
      return if pretend_execution?

      IO.popen(@pipe.shell_command, 'r+', err: %i[child out]) do |pipe|
        execute_simple_command { |out| pipe.puts out }
      end
    end

    def pretend_execution?
      !ENV['PRETEND_COMMAND_EXECUTION'].nil?
    end
  end
end
