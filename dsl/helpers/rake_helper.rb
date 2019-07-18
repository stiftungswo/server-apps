# frozen_string_literal: true

require 'rake'

module DSL
  module Helpers
    module RakeHelper
      def self.execute_rake_command(command, *args)
        app = Rake.application
        app.init
        app.load_rakefile
        app[command].invoke(*args)
      end
    end
  end
end
