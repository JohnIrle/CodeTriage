# frozen_string_literal: true
require 'json'

module DependencyParser
  module JavaScript
    class Parse
      def initialize(content)
        @content = content
      end

      def call
        package = JSON.parse(content)
        @deps = package["dependencies"].map {|key|
          { name: key[0], version: key[1] }
        }
        @dev_deps = package["devDependencies"].map { |key|
          { name: key[0], version: key[1] }
        }
      end

      def direct
        { dependencies: @deps, devDependencies: @dev_deps, language: "javascript" }
      end

      private

      attr_reader :content
    end
  end
end
