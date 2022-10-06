# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/dependency_parser/javascript/parse'

class BundleParseTest < ActiveSupport::TestCase
  test "returns nothing on invalid Gemfile.lock" do
    parser = DependencyParser::JavaScript::Parse.new("invalid")
    parser.call
    assert_equal [], parser.direct
  end

  test "returns list of dependencies and devDependencies" do
    gemfile_lock = <<~JSON
      {
        "name": "new",
        "version": "1.0.0",
        "description": "",
        "main": "index.js",
        "scripts": {
          "test": "jest"
        },
        "keywords": [],
        "author": "",
        "license": "ISC",
        "dependencies": {
          "react": "^18.2.0"
        },
        "devDependencies": {
          "eslint": "^8.24.0"
        }
      }
    JSON

    parser = DependencyParser::JavaScript::Parse.new(gemfile_lock)
    VCR.use_cassette("dependency_parser/javascriptpackage") do
      parser.call
    end

    package_data = {
      dependencies: [{
        name: "react",
        version: "^18.2.0"
      }],
      devDependencies: [{
        name: "eslint",
        version: "^8.24.0"
      }],
      language: "javascript"
    }

    assert_equal package_data, parser.direct
  end
end
