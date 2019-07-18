# frozen_string_literal: true

require 'dotenv'

module DSL
  module Helpers
    module EnvironmentLoader
      def load_environment_file(file)
        Dotenv.load(file)
      end
    end
  end
end
