# frozen_string_literal: true

module Helpers
  module Shell
    def execute_command(command, &block)
      puts "+ #{command.join(' ')}"

      reader = block_given? ? block : method(:puts)
      IO.popen(command, err: %i[child out]).each(&reader)
    end

    def execute_command_with_pipe(_left_command, right_command)
      IO.popen(command, 'r+', err: %i[child out]) do |_pipe|
        execute_command(right_command)
      end
    end
  end
end
