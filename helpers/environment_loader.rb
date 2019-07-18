# frozen_string_literal: true

require 'dotenv'

module Helpers
  module EnvironmentLoader
    def load_environment_file(file)
      Dotenv.load(file)
    end
  end
end
