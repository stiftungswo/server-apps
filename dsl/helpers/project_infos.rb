# frozen_string_literal: true

require 'pathname'

module DSL
  module Helpers
    module ProjectInfos
      def project_name
        project_name = project_path_fragments[-2]
        project_name.gsub('-', '_')
      end

      def project_environment
        project_path_fragments.last
      end

      private

      def project_path_fragments
        Pathname(site_directory).each_filename.to_a
      end
    end
  end
end
