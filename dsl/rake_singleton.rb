# frozen_string_literal: true

require 'rake'
require 'singleton'

module DSL
  class RakeSingleton
    include Singleton

    attr_reader :rake_app

    def initialize
      @rake_app = Rake.application
      @rake_app.init
      @rake_app.load_rakefile
    end
  end
end
