# frozen_string_literal: true

require 'dotenv'

module DSL
  module Helpers
    module EnvironmentLoader
      def load_environment_file(file = nil)
        Dotenv.load(file || default_env_file)
      end

      def default_env_file
        "#{site_directory}/.env"
      end
    end
  end
end
