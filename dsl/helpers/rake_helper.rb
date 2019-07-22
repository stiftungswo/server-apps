# frozen_string_literal: true

require_relative '../rake_singleton'

module DSL
  module Helpers
    module RakeHelper
      def self.execute_rake_command(command, *args)
        DSL::RakeSingleton.instance.rake_app[command].invoke(*args)
      end
    end
  end
end
